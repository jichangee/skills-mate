import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject private var store: SkillsStore
    @State private var customURLText = ""
    @State private var selectedGitHubSkillIDs: Set<String> = []
    @State private var showError = false
    @State private var showSuccess = false

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
        .onReceive(store.$lastSuccessMessage) { message in
            showSuccess = message != nil
        }
        .alert("发生错误", isPresented: $showError) {
            Button("知道了") {
                store.lastErrorMessage = nil
            }
        } message: {
            Text(store.lastErrorMessage ?? "")
        }
        .alert("操作成功", isPresented: $showSuccess) {
            Button("知道了") {
                store.lastSuccessMessage = nil
            }
        } message: {
            Text(store.lastSuccessMessage ?? "")
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
                    .autocorrectionDisabled(true)
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
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    if let avatarURL = item.authorAvatar, let url = URL(string: avatarURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.name)
                                .font(.headline)
                            Spacer()
                            Button("安装") {
                                if let githubUrl = item.githubUrl, let url = URL(string: githubUrl) {
                                    store.loadGitHubSkills(from: url)
                                } else if let downloadURL = item.downloadURL {
                                    store.installFromMarketplace(url: downloadURL, to: .claude)
                                } else {
                                    store.lastErrorMessage = "该技能暂无安装方式"
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        HStack(spacing: 8) {
                            Text(item.author)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            if let stars = item.stars {
                                HStack(spacing: 2) {
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                    Text("\(formatNumber(stars))")
                                        .font(.caption)
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            if let forks = item.forks {
                                HStack(spacing: 2) {
                                    Image(systemName: "tuningfork")
                                        .font(.caption)
                                    Text("\(formatNumber(forks))")
                                        .font(.caption)
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            if let githubUrl = item.githubUrl, let url = URL(string: githubUrl) {
                                Link(destination: url) {
                                    Image(systemName: "link")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                
                Text(item.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                if !item.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .listStyle(.inset)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            return String(format: "%.1fk", Double(number) / 1000.0)
        }
        return "\(number)"
    }
}
