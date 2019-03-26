import Foundation
struct Lesson: Codable {
    let studentsAttended: [String]
    let type: String
    let moduleId: String
    let startTime: String
    let endTime: String
    let date: String
    let roomNumber: String
}
