import Foundation

struct Card: Identifiable, Hashable {
    let id: String
    let front: String
    let back: String
    let deck: String

    init(front: String, back: String, deck: String) {
        self.front = front.trimmingCharacters(in: .whitespacesAndNewlines)
        self.back = back.trimmingCharacters(in: .whitespacesAndNewlines)
        self.deck = deck
        var hasher = Hasher()
        hasher.combine(deck)
        hasher.combine(self.front)
        self.id = String(abs(hasher.finalize()))
    }
}
