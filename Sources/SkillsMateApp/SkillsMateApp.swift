import SwiftUI

@main
struct SkillsMateApp: App {
    @StateObject private var store = SkillsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
