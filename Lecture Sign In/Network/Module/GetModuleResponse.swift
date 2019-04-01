import Foundation

class GetModuleResponse: Codable {
    let module: Module
    let lessons: [Lesson]
}
