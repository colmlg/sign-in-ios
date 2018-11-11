import Foundation

extension Encodable {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
