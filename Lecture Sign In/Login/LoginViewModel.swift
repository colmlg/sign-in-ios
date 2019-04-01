import Foundation
import RxSwift
import KeychainSwift
import PKHUD

class LoginViewModel {
    
    let username = Variable<String>("")
    let password = Variable<String>("")
    
    private let service = LoginService()
    private let disposeBag = DisposeBag()

    var isUserLoggedIn: Bool {
        let users = Repository<User>().findAll()
        return users.count > 0
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        service.login(request: LoginRequest(id: username.value, password: password.value)).subscribe(onNext: { response in
            KeychainSwift().set(response.token, forKey: "Access Token")
            
            let user = User()
            user.studentNumber = self.username.value
            Repository<User>().save(object: user)
            
            completion(response.imageSet ?? true)
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
    }
}
