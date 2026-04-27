import Foundation

enum Grade: Int {
    case again = 0
    case hard = 3
    case good = 4
    case easy = 5
}

struct SM2Engine {
    static func review(state: ReviewState, grade: Grade) -> ReviewState {
        var new = state
        let q = Double(grade.rawValue)

        if grade == .again {
            new.repetitions = 0
            new.interval = 1
        } else {
            if new.repetitions == 0 {
                new.interval = 1
            } else if new.repetitions == 1 {
                new.interval = 6
            } else {
                new.interval = max(1, Int(Double(new.interval) * new.easeFactor))
            }
            new.repetitions += 1
        }

        new.easeFactor += 0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02)
        new.easeFactor = max(1.3, new.easeFactor)

        if grade == .hard {
            new.interval = max(1, Int(Double(new.interval) * 0.8))
        } else if grade == .easy {
            new.interval = Int(Double(new.interval) * 1.3)
        }

        new.nextReview = Calendar.current.date(byAdding: .day, value: new.interval, to: Date()) ?? Date()
        return new
    }
}
