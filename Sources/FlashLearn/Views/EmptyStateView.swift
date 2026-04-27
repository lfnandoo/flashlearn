import SwiftUI

struct EmptyStateView: View {
    let hasCards: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasCards ? "checkmark.circle" : "rectangle.stack.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            if hasCards {
                Text("All caught up!")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("No cards are due for review right now.")
                    .foregroundColor(.secondary)
            } else {
                Text("No cards found")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Add .md files to ~/.flashlearn/cards/")
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
