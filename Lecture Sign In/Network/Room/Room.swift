import Foundation
import RealmSwift
class Room: Object, Codable {
    @objc dynamic var roomNumber = ""
    //swiftlint:disable identifier_name
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
