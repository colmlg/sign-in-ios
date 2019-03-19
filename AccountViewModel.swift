import Foundation

class AccountViewModel {
    
    let user: User?
    let repo = Repository<User>()
    
    init() {
        user = repo.findOne(key: "User")
    }
    
    func logout() {
        if let user = user {
            repo.remove(user)
        }
    }
}
