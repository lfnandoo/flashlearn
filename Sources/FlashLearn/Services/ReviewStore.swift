import Foundation

class ReviewStore {
    private let fileURL: URL
    private var states: [String: ReviewState] = [:]

    init() {
        let dir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".flashlearn")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("reviews.json")
        load()
    }

    func stateFor(_ cardId: String) -> ReviewState {
        states[cardId] ?? ReviewState()
    }

    func update(_ cardId: String, state: ReviewState) {
        states[cardId] = state
        save()
    }

    func isDue(_ cardId: String) -> Bool {
        let state = stateFor(cardId)
        return state.nextReview <= Date()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let decoded = try? decoder.decode([String: ReviewState].self, from: data) else { return }
        states = decoded
    }

    private func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(states) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
