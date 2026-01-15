import Foundation

struct Skill: Identifiable {
    let id: URL
    let name: String
    let location: SkillLocation
    let folderURL: URL
    let isEnabled: Bool
    let hasManifest: Bool
}
