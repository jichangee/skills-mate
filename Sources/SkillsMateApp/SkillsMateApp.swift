import SwiftUI
import AppKit

// AppDelegate 用于处理应用启动后的窗口激活
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 激活应用
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        // 确保主窗口获得焦点
        if let window = NSApplication.shared.windows.first {
            window.makeKeyAndOrderFront(nil)
            window.level = .normal
            window.collectionBehavior = [.managed, .participatesInCycle]
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct SkillsMateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var store = SkillsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .commands {
            // 确保窗口可以正常响应命令
            CommandGroup(replacing: .newItem) { }
        }
    }
}
