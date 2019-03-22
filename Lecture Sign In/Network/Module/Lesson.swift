import Foundation
class Lesson: Codable {
    let studentsAttended: [String]
    let type: String
    let moduleId: String
    let startTime: String
    let endTime: String
    let date: Date
    let roomNumber: String
}
