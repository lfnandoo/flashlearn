import SwiftUI
import Carbon.HIToolbox

struct ReviewView: View {
    @ObservedObject var appState: AppState
    @State private var keyMonitor: Any?

    var body: some View {
        NavigationSplitView {
            DeckPickerView(appState: appState)
                .frame(minWidth: 160)
        } detail: {
            VStack(spacing: 0) {
                if let card = appState.currentCard {
                    HStack {
                        Text(card.deck)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(appState.cardsRemaining) remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    CardView(
                        card: card,
                        showingAnswer: appState.showingAnswer,
                        onReveal: { appState.revealAnswer() },
                        onGrade: { grade in appState.gradeCurrentCard(grade) }
                    )
                } else {
                    EmptyStateView(hasCards: !appState.allCards.isEmpty)
                }
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            appState.loadCards()
            installKeyMonitor()
        }
        .onDisappear {
            removeKeyMonitor()
        }
    }

    private func installKeyMonitor() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if handleKey(event) { return nil }
            return event
        }
    }

    private func removeKeyMonitor() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }

    private func handleKey(_ event: NSEvent) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        guard flags.isEmpty || flags == .numericPad else { return false }

        if event.keyCode == UInt16(kVK_Space) && !appState.showingAnswer {
            appState.revealAnswer()
            return true
        }

        guard appState.showingAnswer else { return false }

        switch event.charactersIgnoringModifiers {
        case "1": appState.gradeCurrentCard(.again); return true
        case "2": appState.gradeCurrentCard(.hard); return true
        case "3": appState.gradeCurrentCard(.good); return true
        case "4": appState.gradeCurrentCard(.easy); return true
        default: return false
        }
    }
}
