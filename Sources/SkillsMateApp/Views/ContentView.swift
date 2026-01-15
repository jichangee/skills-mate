import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        TabView {
            LocalSkillsView()
                .tabItem {
                    Label("本地技能", systemImage: "folder")
                }

            MarketplaceView()
                .tabItem {
                    Label("市场", systemImage: "cart")
                }
        }
        .frame(minWidth: 900, minHeight: 600)
        .onAppear {
            // 延迟确保窗口激活
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }
        }
    }
}
