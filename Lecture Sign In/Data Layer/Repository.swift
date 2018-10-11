import Foundation
import  RealmSwift

class Repository<T: Object> {
    
    let realm = try? Realm()
    
    func findOne(key: String) -> T? {
        return realm?.object(ofType: T.self, forPrimaryKey: key)
    }
    
    func findAll() -> [T] {
        return realm?.objects(T.self).map { $0 } ?? []
    }
    
    func save(object: T) {
        do {
            try realm?.write {
                realm?.add(object, update: true)
            }
        } catch {
            print("Error saving object of type \(T.self)")
            print(error.localizedDescription)
        }
    }
}
