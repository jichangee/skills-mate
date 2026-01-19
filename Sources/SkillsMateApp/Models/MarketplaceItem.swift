import Foundation

struct MarketplaceItem: Identifiable, Hashable {
    let id: String
    let name: String
    let summary: String
    let author: String
    let authorAvatar: String?
    let tags: [String]
    let downloadURL: URL?
    let githubUrl: String?
    let stars: Int?
    let forks: Int?
    let updatedAt: TimeInterval?
    let branch: String
    let path: String

    init(
        id: String = UUID().uuidString,
        name: String,
        summary: String,
        author: String,
        authorAvatar: String? = nil,
        tags: [String] = [],
        downloadURL: URL? = nil,
        githubUrl: String? = nil,
        stars: Int? = nil,
        forks: Int? = nil,
        updatedAt: TimeInterval? = nil,
        branch: String = "main",
        path: String = "SKILL.md"
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.author = author
        self.authorAvatar = authorAvatar
        self.tags = tags
        self.downloadURL = downloadURL
        self.githubUrl = githubUrl
        self.stars = stars
        self.forks = forks
        self.updatedAt = updatedAt
        self.branch = branch
        self.path = path
    }
}
