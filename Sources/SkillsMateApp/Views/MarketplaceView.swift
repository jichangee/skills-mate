import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject private var store: SkillsStore
    @State private var customURLText = ""
    @State private var selectedGitHubSkillIDs: Set<String> = []
    @State private var showError = false

    var body: some View {
        VStack(spacing: 16) {
            header
            customInstall
            githubSkillsList
            marketplaceList
        }
        .padding()
        .onReceive(store.$githubSkills) { skills in
            selectedGitHubSkillIDs = Set(skills.map { $0.id })
        }
        .onReceive(store.$lastErrorMessage) { message in
            showError = message != nil
        }
        .alert("发生错误", isPresented: $showError) {
            Button("知道了") {
                store.lastErrorMessage = nil
            }
        } message: {
            Text(store.lastErrorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("技能市场")
                    .font(.title2)
                Text("从市场下载技能并安装到指定目录。")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("安装到 ~/.claude/skills")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var customInstall: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GitHub 仓库地址")
                .font(.headline)
            HStack {
                TextField("https://github.com/owner/repo", text: $customURLText)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .frame(minWidth: 360)
                Button("解析") {
                    guard let url = URL(string: customURLText) else {
                        store.lastErrorMessage = "GitHub 地址无效"
                        return
                    }
                    store.loadGitHubSkills(from: url)
                }
                .disabled(customURLText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || store.isLoadingGitHub)
                if store.isLoadingGitHub {
                    ProgressView()
                        .controlSize(.small)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }

    private var githubSkillsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("仓库技能列表")
                    .font(.headline)
                Spacer()
                if let repo = store.githubRepo {
                    Text("\(repo.owner)/\(repo.repo) · \(repo.branch)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if store.githubSkills.isEmpty {
                Text("解析后会在这里显示 .claude/skills 下的技能列表。")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(store.githubSkills) { skill in
                            Toggle(isOn: Binding(
                                get: { selectedGitHubSkillIDs.contains(skill.id) },
                                set: { isOn in
                                    if isOn {
                                        selectedGitHubSkillIDs.insert(skill.id)
                                    } else {
                                        selectedGitHubSkillIDs.remove(skill.id)
                                    }
                                }
                            )) {
                                Text(skill.name)
                            }
                            .toggleStyle(.checkbox)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxHeight: 180)

                HStack {
                    Button("全选") {
                        selectedGitHubSkillIDs = Set(store.githubSkills.map { $0.id })
                    }
                    Button("清空") {
                        selectedGitHubSkillIDs.removeAll()
                    }
                    Spacer()
                    Button("安装已选") {
                        store.installGitHubSkills(ids: selectedGitHubSkillIDs, to: .claude)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedGitHubSkillIDs.isEmpty || store.isLoadingGitHub)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }

    private var marketplaceList: some View {
        List(store.marketplaceItems) { item in
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    Spacer()
                    Button("下载") {
                        guard let url = item.downloadURL else {
                            store.lastErrorMessage = "该条目暂无下载链接"
                            return
                        }
                        store.installFromMarketplace(url: url, to: .claude)
                    }
                    .buttonStyle(.borderedProminent)
                }
                Text(item.summary)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text("作者：\(item.author)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if !item.tags.isEmpty {
                        Text(item.tags.joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.vertical, 6)
        }
        .listStyle(.inset)
    }
}
