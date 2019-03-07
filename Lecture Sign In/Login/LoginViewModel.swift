import Foundation
import RxSwift
import KeychainSwift
import PKHUD

class LoginViewModel {
    
    let username = Variable<String>("")
    let password = Variable<String>("")
    
    private let service = LoginService()
    private let disposeBag = DisposeBag()

    func login(completion: @escaping () -> Void) {
        service.login(request: LoginRequest(id: username.value, password: password.value)).subscribe(onNext: { response in
            KeychainSwift().set(response.token, forKey: "Access Token")
            completion()
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
    }
}
