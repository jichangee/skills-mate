import Foundation

struct GitHubSkill: Identifiable, Hashable {
    let id: String
    let name: String
    let path: String
}

struct GitHubRepoReference: Equatable {
    let owner: String
    let repo: String
    let branch: String
}
