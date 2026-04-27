import SwiftUI

@main
struct FlashLearnApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        MenuBarExtra(appDelegate.snoozeManager.isSnoozed ? "FlashLearn (Snoozed)" : "FlashLearn",
                     systemImage: appDelegate.snoozeManager.isSnoozed ? "moon.zzz" : "brain.head.profile") {
            Button("Review Now") {
                openWindow(id: "review")
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
            .keyboardShortcut("r")

            Divider()

            if appDelegate.snoozeManager.isSnoozed {
                if let remaining = appDelegate.snoozeManager.snoozeRemaining {
                    Text("Snoozed: \(remaining) left")
                }
                Button("Wake Up") {
                    appDelegate.snoozeManager.clearSnooze()
                }
            } else {
                Menu("Snooze") {
                    Button("15 minutes") { appDelegate.snoozeManager.snooze(minutes: 15) }
                    Button("30 minutes") { appDelegate.snoozeManager.snooze(minutes: 30) }
                    Button("1 hour") { appDelegate.snoozeManager.snooze(minutes: 60) }
                    Button("2 hours") { appDelegate.snoozeManager.snooze(minutes: 120) }
                    Button("Rest of day") { appDelegate.snoozeManager.snoozeUntilEndOfDay() }
                }
            }

            Divider()

            Text("\(appState.allCards.count) cards, \(appState.dueCards.count) due")
                .foregroundColor(.secondary)

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }

        Window("FlashLearn", id: "review") {
            ReviewView(appState: appState)
        }
        .defaultSize(width: 700, height: 500)
    }
}
