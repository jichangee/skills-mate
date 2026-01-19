import Foundation

enum MarketplaceCatalog {
    static var defaultItems: [MarketplaceItem] {
        [
            MarketplaceItem(
                id: "n8n-io-n8n-claude-skills-create-pr-skill-md",
                name: "create-pr",
                summary: "Creates GitHub pull requests with properly formatted titles that pass the check-pr-title CI validation. Use when creating PRs, submitting changes for review, or when the user says /pr or asks to create a pull request.",
                author: "n8n-io",
                authorAvatar: "https://avatars.githubusercontent.com/u/45487711?v=4",
                githubUrl: "https://github.com/n8n-io/n8n",
                stars: 169650,
                forks: 53724,
                updatedAt: 1768695723,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "f-awesome-chatgpt-prompts-plugins-claude-prompts-chat-skills-skill-lookup-skill-md",
                name: "skill-lookup",
                summary: "Activates when the user asks about Agent Skills, wants to find reusable AI capabilities, needs to install skills, or mentions skills for Claude. Use for discovering, retrieving, and installing skills.",
                author: "f",
                authorAvatar: "https://avatars.githubusercontent.com/u/196477?u=2d5bb396cb53e269ad990995ff95e02d60fd0694&v=4",
                githubUrl: "https://github.com/f/awesome-chatgpt-prompts",
                stars: 142552,
                forks: 18923,
                updatedAt: 1768707410,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "f-awesome-chatgpt-prompts-plugins-claude-prompts-chat-skills-prompt-lookup-skill-md",
                name: "prompt-lookup",
                summary: "Activates when the user asks about AI prompts, needs prompt templates, wants to search for prompts, or mentions prompts.chat. Use for discovering, retrieving, and improving prompts.",
                author: "f",
                authorAvatar: "https://avatars.githubusercontent.com/u/196477?u=2d5bb396cb53e269ad990995ff95e02d60fd0694&v=4",
                githubUrl: "https://github.com/f/awesome-chatgpt-prompts",
                stars: 142552,
                forks: 18923,
                updatedAt: 1768707410,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "langgenius-dify-claude-skills-frontend-code-review-skill-md",
                name: "frontend-code-review",
                summary: "Trigger when the user requests a review of frontend files (e.g., `.tsx`, `.ts`, `.js`). Support both pending-change reviews and focused file reviews while applying the checklist rules.",
                author: "langgenius",
                authorAvatar: "https://avatars.githubusercontent.com/u/127165244?v=4",
                githubUrl: "https://github.com/langgenius/dify",
                stars: 126274,
                forks: 19667,
                updatedAt: 1768703879,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "langgenius-dify-claude-skills-component-refactoring-skill-md",
                name: "component-refactoring",
                summary: "Refactor high-complexity React components in Dify frontend. Use when `pnpm analyze-component --json` shows complexity > 50 or lineCount > 300, when the user asks for code splitting, hook extraction, or complexity reduction, or when `pnpm analyze-component` warns to refactor before testing; avoid for simple/well-structured components, third-party wrappers, or when the user explicitly wants testing without refactoring.",
                author: "langgenius",
                authorAvatar: "https://avatars.githubusercontent.com/u/127165244?v=4",
                githubUrl: "https://github.com/langgenius/dify",
                stars: 126274,
                forks: 19667,
                updatedAt: 1768703879,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "langgenius-dify-claude-skills-orpc-contract-first-skill-md",
                name: "orpc-contract-first",
                summary: "Guide for implementing oRPC contract-first API patterns in Dify frontend. Triggers when creating new API contracts, adding service endpoints, integrating TanStack Query with typed contracts, or migrating legacy service calls to oRPC. Use for all API layer work in web/contract and web/service directories.",
                author: "langgenius",
                authorAvatar: "https://avatars.githubusercontent.com/u/127165244?v=4",
                githubUrl: "https://github.com/langgenius/dify",
                stars: 126274,
                forks: 19667,
                updatedAt: 1768703879,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "langgenius-dify-claude-skills-skill-creator-skill-md",
                name: "skill-creator",
                summary: "Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.",
                author: "langgenius",
                authorAvatar: "https://avatars.githubusercontent.com/u/127165244?v=4",
                githubUrl: "https://github.com/langgenius/dify",
                stars: 126274,
                forks: 19667,
                updatedAt: 1768703879,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "langgenius-dify-claude-skills-frontend-testing-skill-md",
                name: "frontend-testing",
                summary: "Generate Vitest + React Testing Library tests for Dify frontend components, hooks, and utilities. Triggers on testing, spec files, coverage, Vitest, RTL, unit tests, integration tests, or write/review test requests.",
                author: "langgenius",
                authorAvatar: "https://avatars.githubusercontent.com/u/127165244?v=4",
                githubUrl: "https://github.com/langgenius/dify",
                stars: 126274,
                forks: 19667,
                updatedAt: 1768703879,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "electron-electron-claude-skills-electron-chromium-upgrade-skill-md",
                name: "electron-chromium-upgrade",
                summary: "Guide for performing Chromium version upgrades in the Electron project. Use when working on the roller/chromium/main branch to fix patch conflicts during `e sync --3`. Covers the patch application workflow, conflict resolution, analyzing upstream Chromium changes, and proper commit formatting for patch fixes.",
                author: "electron",
                authorAvatar: "https://avatars.githubusercontent.com/u/13409222?v=4",
                githubUrl: "https://github.com/electron/electron",
                stars: 119793,
                forks: 16928,
                updatedAt: 1768627152,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "pytorch-pytorch-claude-skills-at-dispatch-v2-skill-md",
                name: "at-dispatch-v2",
                summary: "Convert PyTorch AT_DISPATCH macros to AT_DISPATCH_V2 format in ATen C++ code. Use when porting AT_DISPATCH_ALL_TYPES_AND*, AT_DISPATCH_FLOATING_TYPES*, or other dispatch macros to the new v2 API. For ATen kernel files, CUDA kernels, and native operator implementations.",
                author: "pytorch",
                authorAvatar: "https://avatars.githubusercontent.com/u/21003710?v=4",
                githubUrl: "https://github.com/pytorch/pytorch",
                stars: 96701,
                forks: 26534,
                updatedAt: 1768708870,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "pytorch-pytorch-claude-skills-docstring-skill-md",
                name: "docstring",
                summary: "Write docstrings for PyTorch functions and methods following PyTorch conventions. Use when writing or updating docstrings in PyTorch code.",
                author: "pytorch",
                authorAvatar: "https://avatars.githubusercontent.com/u/21003710?v=4",
                githubUrl: "https://github.com/pytorch/pytorch",
                stars: 96701,
                forks: 26534,
                updatedAt: 1768708870,
                branch: "main",
                path: "SKILL.md"
            ),
            MarketplaceItem(
                id: "pytorch-pytorch-claude-skills-skill-writer-skill-md",
                name: "skill-writer",
                summary: "Guide users through creating Agent Skills for Claude Code. Use when the user wants to create, write, author, or design a new Skill, or needs help with SKILL.md files, frontmatter, or skill structure.",
                author: "pytorch",
                authorAvatar: "https://avatars.githubusercontent.com/u/21003710?v=4",
                githubUrl: "https://github.com/pytorch/pytorch",
                stars: 96701,
                forks: 26534,
                updatedAt: 1768708870,
                branch: "main",
                path: "SKILL.md"
            )
        ]
    }
}
