import Foundation

enum MarketplaceCatalog {
    static var defaultItems: [MarketplaceItem] {
        [
            MarketplaceItem(
                name: "starter-skill-pack",
                summary: "示例技能包（需要替换成真实市场链接）。",
                author: "Skills Mate",
                tags: ["example", "starter"],
                downloadURL: nil
            ),
            MarketplaceItem(
                name: "writing-skills",
                summary: "写作类技能示例（需要替换成真实市场链接）。",
                author: "Skills Mate",
                tags: ["example"],
                downloadURL: nil
            )
        ]
    }
}
