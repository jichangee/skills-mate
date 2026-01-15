import Foundation

struct MarketplaceItem: Identifiable, Hashable {
    let id: UUID
    let name: String
    let summary: String
    let author: String
    let tags: [String]
    let downloadURL: URL?

    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        author: String,
        tags: [String],
        downloadURL: URL?
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.author = author
        self.tags = tags
        self.downloadURL = downloadURL
    }
}
