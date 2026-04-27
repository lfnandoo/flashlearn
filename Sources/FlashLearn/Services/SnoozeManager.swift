import Foundation

class SnoozeManager {
    private let fileURL: URL

    init() {
        let dir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".flashlearn")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("snooze")
    }

    var isSnoozed: Bool {
        guard let content = try? String(contentsOf: fileURL, encoding: .utf8),
              let timestamp = TimeInterval(content.trimmingCharacters(in: .whitespacesAndNewlines))
        else { return false }
        return Date().timeIntervalSince1970 < timestamp
    }

    var snoozeRemaining: String? {
        guard let content = try? String(contentsOf: fileURL, encoding: .utf8),
              let timestamp = TimeInterval(content.trimmingCharacters(in: .whitespacesAndNewlines))
        else { return nil }
        let remaining = timestamp - Date().timeIntervalSince1970
        guard remaining > 0 else { return nil }
        let minutes = Int(remaining / 60)
        if minutes >= 60 {
            return "\(minutes / 60)h \(minutes % 60)m"
        }
        return "\(minutes)m"
    }

    func snooze(minutes: Int) {
        let until = Date().timeIntervalSince1970 + Double(minutes * 60)
        try? String(Int(until)).write(to: fileURL, atomically: true, encoding: .utf8)
    }

    func snoozeUntilEndOfDay() {
        let endOfDay = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        try? String(Int(endOfDay.timeIntervalSince1970)).write(to: fileURL, atomically: true, encoding: .utf8)
    }

    func clearSnooze() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
