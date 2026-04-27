import SwiftUI

struct DeckPickerView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Decks")
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            List(selection: Binding(
                get: { appState.selectedDeck },
                set: { appState.selectDeck($0) }
            )) {
                Label("All Cards (\(appState.allCards.count))", systemImage: "rectangle.stack")
                    .tag(nil as String?)

                ForEach(appState.decks, id: \.self) { deck in
                    let count = appState.allCards.filter { $0.deck == deck }.count
                    Label("\(deck) (\(count))", systemImage: "rectangle.on.rectangle")
                        .tag(deck as String?)
                }
            }
            .listStyle(.sidebar)
        }
    }
}
