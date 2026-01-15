import Foundation
import AppKit

@MainActor
final class SkillsStore: ObservableObject {
    @Published private(set) var skills: [Skill] = []
    @Published private(set) var marketplaceItems: [MarketplaceItem] = MarketplaceCatalog.defaultItems
    @Published private(set) var githubSkills: [GitHubSkill] = []
    @Published private(set) var githubRepo: GitHubRepoReference?
    @Published private(set) var isLoadingGitHub = false
    @Published var isRefreshing = false
    @Published var lastErrorMessage: String?
    @Published var lastSuccessMessage: String?

    init() {
        refresh()
    }

    func refresh() {
        isRefreshing = true
        Task {
            defer { isRefreshing = false }
            do {
                skills = try await loadSkills()
            } catch {
                lastErrorMessage = "刷新失败：\(error.localizedDescription)"
            }
        }
    }

    func openInFinder(_ skill: Skill) {
        NSWorkspace.shared.activateFileViewerSelecting([skill.folderURL])
    }
    
    func delete(_ skill: Skill) {
        Task {
            do {
                try moveToTrash(skill)
                skills = try await loadSkills()
                lastSuccessMessage = "技能 \"\(skill.name)\" 已成功删除"
            } catch {
                lastErrorMessage = "删除失败：\(error.localizedDescription)"
            }
        }
    }

    func toggle(skill: Skill) {
        Task {
            do {
                if skill.isEnabled {
                    try disable(skill)
                } else {
                    try enable(skill)
                }
                skills = try await loadSkills()
            } catch {
                lastErrorMessage = "操作失败：\(error.localizedDescription)"
            }
        }
    }

    func installFromMarketplace(url: URL, to location: SkillLocation) {
        Task {
            do {
                try await installSkill(from: url, to: location)
                skills = try await loadSkills()
            } catch {
                lastErrorMessage = "下载失败：\(error.localizedDescription)"
            }
        }
    }

    func loadGitHubSkills(from url: URL) {
        Task {
            do {
                isLoadingGitHub = true
                defer { isLoadingGitHub = false }
                let repo = try await resolveGitHubRepo(from: url)
                let skills = try await fetchGitHubSkills(for: repo)
                githubRepo = repo
                githubSkills = skills
            } catch {
                isLoadingGitHub = false
                lastErrorMessage = "解析失败：\(error.localizedDescription)"
            }
        }
    }

    func installGitHubSkills(ids: Set<String>, to location: SkillLocation) {
        Task {
            do {
                isLoadingGitHub = true
                defer { isLoadingGitHub = false }
                guard let repo = githubRepo else {
                    throw NSError(domain: "SkillsMate", code: 7, userInfo: [
                        NSLocalizedDescriptionKey: "请先解析 GitHub 地址"
                    ])
                }
                try await installGitHubSkills(from: repo, ids: ids, to: location)
                skills = try await loadSkills()
                let count = ids.count
                lastSuccessMessage = "成功安装 \(count) 个技能"
            } catch {
                isLoadingGitHub = false
                lastErrorMessage = "安装失败：\(error.localizedDescription)"
            }
        }
    }

    private func loadSkills() async throws -> [Skill] {
        var results: [Skill] = []
        for location in SkillLocation.allCases {
            results.append(contentsOf: try scanSkills(
                at: location.baseURL,
                location: location,
                isEnabled: true
            ))
            results.append(contentsOf: try scanSkills(
                at: location.disabledBaseURL,
                location: location,
                isEnabled: false
            ))
        }
        return results.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    private func scanSkills(
        at baseURL: URL,
        location: SkillLocation,
        isEnabled: Bool
    ) throws -> [Skill] {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: baseURL.path) else { return [] }

        let contents = try fileManager.contentsOfDirectory(
            at: baseURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        return contents.compactMap { url in
            guard let resourceValues = try? url.resourceValues(forKeys: [.isDirectoryKey]),
                  resourceValues.isDirectory == true else { return nil }
            let manifestURL = url.appendingPathComponent("SKILL.md")
            let hasManifest = fileManager.fileExists(atPath: manifestURL.path)
            return Skill(
                id: url,
                name: url.lastPathComponent,
                location: location,
                folderURL: url,
                isEnabled: isEnabled,
                hasManifest: hasManifest
            )
        }
    }

    private func disable(_ skill: Skill) throws {
        let destinationBase = skill.location.disabledBaseURL
        try ensureDirectoryExists(destinationBase)
        let targetURL = uniqueDestinationURL(
            base: destinationBase,
            preferredName: skill.folderURL.lastPathComponent
        )
        try FileManager.default.moveItem(at: skill.folderURL, to: targetURL)
    }

    private func enable(_ skill: Skill) throws {
        let destinationBase = skill.location.baseURL
        try ensureDirectoryExists(destinationBase)
        let targetURL = uniqueDestinationURL(
            base: destinationBase,
            preferredName: skill.folderURL.lastPathComponent
        )
        try FileManager.default.moveItem(at: skill.folderURL, to: targetURL)
    }
    
    private func moveToTrash(_ skill: Skill) throws {
        try NSWorkspace.shared.recycle([skill.folderURL], completionHandler: nil)
    }

    private func ensureDirectoryExists(_ url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    private func uniqueDestinationURL(base: URL, preferredName: String) -> URL {
        let fileManager = FileManager.default
        var candidate = base.appendingPathComponent(preferredName)
        var suffix = 1
        while fileManager.fileExists(atPath: candidate.path) {
            candidate = base.appendingPathComponent("\(preferredName)-\(suffix)")
            suffix += 1
        }
        return candidate
    }

    private func installSkill(from downloadURL: URL, to location: SkillLocation) async throws {
        guard downloadURL.pathExtension.lowercased() == "zip" else {
            throw NSError(domain: "SkillsMate", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "仅支持 zip 包下载"
            ])
        }

        let fileManager = FileManager.default
        let tempFolder = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fileManager.createDirectory(at: tempFolder, withIntermediateDirectories: true)
        let destinationZip = tempFolder.appendingPathComponent("skill.zip")

        let (downloadedURL, _) = try await URLSession.shared.download(from: downloadURL)
        try fileManager.moveItem(at: downloadedURL, to: destinationZip)

        try unzip(zipURL: destinationZip, to: tempFolder)

        guard let skillFolder = findSkillFolder(in: tempFolder) else {
            throw NSError(domain: "SkillsMate", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "未在压缩包内找到 SKILL.md"
            ])
        }

        let destinationBase = location.baseURL
        try ensureDirectoryExists(destinationBase)
        let targetURL = uniqueDestinationURL(base: destinationBase, preferredName: skillFolder.lastPathComponent)
        try fileManager.moveItem(at: skillFolder, to: targetURL)
    }

    private func installGitHubSkills(from repo: GitHubRepoReference, ids: Set<String>, to location: SkillLocation) async throws {
        guard !ids.isEmpty else {
            throw NSError(domain: "SkillsMate", code: 8, userInfo: [
                NSLocalizedDescriptionKey: "请选择至少一个技能"
            ])
        }

        let fileManager = FileManager.default
        let tempFolder = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fileManager.createDirectory(at: tempFolder, withIntermediateDirectories: true)
        let destinationZip = tempFolder.appendingPathComponent("repo.zip")

        let zipURL = URL(string: "https://codeload.github.com/\(repo.owner)/\(repo.repo)/zip/refs/heads/\(repo.branch)")!
        let (downloadedURL, _) = try await URLSession.shared.download(from: zipURL)
        try fileManager.moveItem(at: downloadedURL, to: destinationZip)

        try unzip(zipURL: destinationZip, to: tempFolder)
        guard let skillsRoot = findSkillsRoot(in: tempFolder) else {
            throw NSError(domain: "SkillsMate", code: 9, userInfo: [
                NSLocalizedDescriptionKey: "未在仓库中找到 .claude/skills"
            ])
        }

        let destinationBase = location.baseURL
        try ensureDirectoryExists(destinationBase)

        for skillID in ids {
            let skillFolder = skillsRoot.appendingPathComponent(skillID)
            guard fileManager.fileExists(atPath: skillFolder.path) else { continue }
            let targetURL = uniqueDestinationURL(base: destinationBase, preferredName: skillID)
            try fileManager.copyItem(at: skillFolder, to: targetURL)
        }
    }

    private func unzip(zipURL: URL, to destination: URL) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-q", zipURL.path, "-d", destination.path]
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw NSError(domain: "SkillsMate", code: 3, userInfo: [
                NSLocalizedDescriptionKey: "解压失败"
            ])
        }
    }

    private func findSkillFolder(in folder: URL) -> URL? {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(at: folder, includingPropertiesForKeys: [.isDirectoryKey]) else {
            return nil
        }

        for case let url as URL in enumerator {
            let manifestURL = url.appendingPathComponent("SKILL.md")
            if fileManager.fileExists(atPath: manifestURL.path) {
                return url
            }
        }
        return nil
    }

    private func findSkillsRoot(in folder: URL) -> URL? {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(at: folder, includingPropertiesForKeys: [.isDirectoryKey]) else {
            return nil
        }

        for case let url as URL in enumerator {
            if url.path.hasSuffix("/.claude/skills") {
                return url
            }
        }
        return nil
    }

    private func resolveGitHubRepo(from url: URL) async throws -> GitHubRepoReference {
        guard let host = url.host?.lowercased(),
              host.contains("github.com") else {
            throw NSError(domain: "SkillsMate", code: 4, userInfo: [
                NSLocalizedDescriptionKey: "仅支持 github.com 地址"
            ])
        }

        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count >= 2 else {
            throw NSError(domain: "SkillsMate", code: 5, userInfo: [
                NSLocalizedDescriptionKey: "GitHub 地址格式不正确"
            ])
        }

        let owner = components[0]
        var repoName = components[1]
        if repoName.hasSuffix(".git") {
            repoName = String(repoName.dropLast(4))
        }

        let branch = parseBranch(from: components)
        if let branch {
            return GitHubRepoReference(owner: owner, repo: repoName, branch: branch)
        }

        let info = try await fetchGitHubRepoInfo(owner: owner, repo: repoName)
        return GitHubRepoReference(owner: owner, repo: repoName, branch: info.defaultBranch)
    }

    private func parseBranch(from components: [String]) -> String? {
        guard let treeIndex = components.firstIndex(of: "tree"),
              components.count > treeIndex + 1 else { return nil }
        return components[treeIndex + 1]
    }

    private struct GitHubRepoInfo: Decodable {
        let defaultBranch: String

        private enum CodingKeys: String, CodingKey {
            case defaultBranch = "default_branch"
        }
    }

    private func fetchGitHubRepoInfo(owner: String, repo: String) async throws -> GitHubRepoInfo {
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(GitHubRepoInfo.self, from: data)
    }

    private struct GitHubTreeResponse: Decodable {
        struct Node: Decodable {
            let path: String
            let type: String
        }

        let tree: [Node]
    }

    private func fetchGitHubSkills(for repo: GitHubRepoReference) async throws -> [GitHubSkill] {
        let url = URL(string: "https://api.github.com/repos/\(repo.owner)/\(repo.repo)/git/trees/\(repo.branch)?recursive=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GitHubTreeResponse.self, from: data)

        let prefix = ".claude/skills/"
        var skillNames: Set<String> = []
        for node in response.tree where node.path.hasSuffix("SKILL.md") && node.path.hasPrefix(prefix) {
            let trimmed = node.path.dropFirst(prefix.count)
            if let skillName = trimmed.split(separator: "/").first {
                skillNames.insert(String(skillName))
            }
        }

        return skillNames
            .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
            .map { name in
                GitHubSkill(id: name, name: name, path: "\(prefix)\(name)")
            }
    }
}
