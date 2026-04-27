import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    let snoozeManager = SnoozeManager()
    private var shortcut: GlobalShortcut?

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard SingleInstance.acquireOrActivateExisting() else {
            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
            return
        }

        SingleInstance.listenForActivation { [weak self] in
            self?.activateReviewWindow()
        }

        shortcut = GlobalShortcut { [weak self] in
            self?.toggleReviewWindow()
        }
        shortcut?.register()

        checkAccessibility()
    }

    func applicationWillTerminate(_ notification: Notification) {
        shortcut?.unregister()
    }

    private func activateReviewWindow() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        if let window = findReviewWindow() {
            window.makeKeyAndOrderFront(nil)
        }
    }

    private func toggleReviewWindow() {
        if let window = findReviewWindow(), window.isVisible,
           NSApplication.shared.isActive {
            window.orderOut(nil)
        } else {
            activateReviewWindow()
        }
    }

    private func findReviewWindow() -> NSWindow? {
        NSApplication.shared.windows.first { $0.title == "FlashLearn" && $0.level == .normal }
    }

    private func checkAccessibility() {
        if !AXIsProcessTrusted() {
            let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
            AXIsProcessTrustedWithOptions(options)
        }
    }
}
