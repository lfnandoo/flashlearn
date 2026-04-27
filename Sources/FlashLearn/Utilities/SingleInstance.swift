import Foundation
import AppKit

struct SingleInstance {
    private static let pidFile = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".flashlearn/pid")
    private static let activateNotification = NSNotification.Name("com.flashlearn.activate")

    static func acquireOrActivateExisting() -> Bool {
        if let content = try? String(contentsOf: pidFile, encoding: .utf8),
           let existingPid = Int32(content.trimmingCharacters(in: .whitespacesAndNewlines)),
           kill(existingPid, 0) == 0 {
            DistributedNotificationCenter.default().postNotificationName(
                activateNotification, object: nil, userInfo: nil, deliverImmediately: true
            )
            return false
        }

        try? String(ProcessInfo.processInfo.processIdentifier).write(to: pidFile, atomically: true, encoding: .utf8)

        return true
    }

    static func listenForActivation(handler: @escaping () -> Void) {
        DistributedNotificationCenter.default().addObserver(
            forName: activateNotification, object: nil, queue: .main
        ) { _ in
            handler()
        }
    }
}
