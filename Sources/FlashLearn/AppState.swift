import Foundation
import Combine

class AppState: ObservableObject {
    @Published var allCards: [Card] = []
    @Published var dueCards: [Card] = []
    @Published var currentIndex: Int = 0
    @Published var showingAnswer: Bool = false
    @Published var selectedDeck: String?

    let reviewStore = ReviewStore()
    let snoozeManager = SnoozeManager()

    var decks: [String] {
        Array(Set(allCards.map(\.deck))).sorted()
    }

    var currentCard: Card? {
        guard currentIndex < dueCards.count else { return nil }
        return dueCards[currentIndex]
    }

    var cardsRemaining: Int {
        max(0, dueCards.count - currentIndex)
    }

    func loadCards() {
        let dir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".flashlearn/cards")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        allCards = CardParser.parseDirectory(dir)
        refreshDueCards()
    }

    func refreshDueCards() {
        let filtered = selectedDeck.map { deck in allCards.filter { $0.deck == deck } } ?? allCards
        dueCards = filtered.filter { reviewStore.isDue($0.id) }.shuffled()
        currentIndex = 0
        showingAnswer = false
    }

    func selectDeck(_ deck: String?) {
        selectedDeck = deck
        refreshDueCards()
    }

    func revealAnswer() {
        showingAnswer = true
    }

    func gradeCurrentCard(_ grade: Grade) {
        guard let card = currentCard else { return }
        let current = reviewStore.stateFor(card.id)
        let updated = SM2Engine.review(state: current, grade: grade)
        reviewStore.update(card.id, state: updated)
        showingAnswer = false
        currentIndex += 1
    }
}
