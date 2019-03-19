import RealmSwift

class User: Object {
    @objc dynamic var studentNumber = ""
    @objc dynamic var key = "User"
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
