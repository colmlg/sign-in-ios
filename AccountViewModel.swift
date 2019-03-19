import Foundation

class AccountViewModel {
    
    let user: User?
    
    init() {
        user = Repository<User>().findOne(key: "User")
    }
    
    func logout() {
        user?.realm?.delete(user!)
    }
}
