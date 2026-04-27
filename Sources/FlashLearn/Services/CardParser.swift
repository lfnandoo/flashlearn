import Foundation

struct CardParser {
    static func parseDirectory(_ url: URL) -> [Card] {
        guard let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        var cards: [Card] = []
        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "md" else { continue }
            cards.append(contentsOf: parseFile(fileURL))
        }
        return cards
    }

    static func parseFile(_ url: URL) -> [Card] {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [] }

        let defaultDeck = url.deletingPathExtension().lastPathComponent
        var deck = defaultDeck
        var body = content

        if content.hasPrefix("---") {
            let parts = content.split(separator: "---", maxSplits: 2, omittingEmptySubsequences: false)
            if parts.count >= 3 {
                let frontmatter = String(parts[1])
                for line in frontmatter.split(separator: "\n") {
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    if trimmed.lowercased().hasPrefix("deck:") {
                        deck = String(trimmed.dropFirst(5)).trimmingCharacters(in: .whitespaces)
                    }
                }
                body = String(parts[2...].joined(separator: "---"))
            }
        }

        var cards: [Card] = []
        let sections = body.components(separatedBy: "\n---")

        for section in sections {
            let lines = section.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
            var front: String?
            var backLines: [String] = []

            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.hasPrefix("# ") && front == nil {
                    front = String(trimmed.dropFirst(2))
                } else if front != nil {
                    backLines.append(line)
                }
            }

            if let front = front {
                let back = backLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                if !back.isEmpty {
                    cards.append(Card(front: front, back: back, deck: deck))
                }
            }
        }

        return cards
    }
}
