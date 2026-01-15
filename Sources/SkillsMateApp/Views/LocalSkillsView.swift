import SwiftUI

struct LocalSkillsView: View {
    @EnvironmentObject private var store: SkillsStore
    @State private var showError = false
    @State private var showSuccess = false

    var body: some View {
        VStack(spacing: 12) {
            header
            skillList
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
                Text("本地技能")
                    .font(.title2)
        Text("扫描 ~/.claude/skills，并支持启用/禁用。")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                store.refresh()
            } label: {
                Label("刷新", systemImage: "arrow.clockwise")
            }
            .disabled(store.isRefreshing)
        }
    }

    private var skillList: some View {
        List {
            HStack {
                Text("名称")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 220, alignment: .leading)
                Text("来源")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 100, alignment: .leading)
                Text("状态")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 80, alignment: .leading)
                Spacer()
                Text("操作")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 220, alignment: .leading)
            }
            .padding(.vertical, 4)

            ForEach(store.skills) { skill in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(skill.name)
                        if !skill.hasManifest {
                            Text("缺少 SKILL.md")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                    .frame(minWidth: 220, alignment: .leading)

                    Text(skill.location.displayName)
                        .frame(width: 100, alignment: .leading)

                    Text(skill.isEnabled ? "已启用" : "已禁用")
                        .foregroundStyle(skill.isEnabled ? .green : .secondary)
                        .frame(width: 80, alignment: .leading)

                    Spacer()

                    HStack(spacing: 12) {
                        Button(skill.isEnabled ? "禁用" : "启用") {
                            store.toggle(skill: skill)
                        }
                        Button("定位") {
                            store.openInFinder(skill)
                        }
                        Button("删除") {
                            store.delete(skill)
                        }
                        .foregroundColor(.red)
                    }
                    .buttonStyle(.bordered)
                    .frame(width: 220, alignment: .leading)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.inset)
    }
}
