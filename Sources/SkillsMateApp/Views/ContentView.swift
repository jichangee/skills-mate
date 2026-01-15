import SwiftUI

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
    }
}
