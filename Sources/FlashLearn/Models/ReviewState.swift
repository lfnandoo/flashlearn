import Foundation

struct ReviewState: Codable {
    var easeFactor: Double = 2.5
    var interval: Int = 0
    var repetitions: Int = 0
    var nextReview: Date = Date.distantPast
}
