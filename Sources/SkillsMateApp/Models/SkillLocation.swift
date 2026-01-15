import Foundation

enum SkillLocation: String, CaseIterable, Identifiable {
    case claude

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .claude:
            return "Claude"
        }
    }

    var baseURL: URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        switch self {
        case .claude:
            return home.appendingPathComponent(".claude/skills")
        }
    }

    var disabledBaseURL: URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent(".skills-mate/disabled/\(rawValue)")
    }
}
