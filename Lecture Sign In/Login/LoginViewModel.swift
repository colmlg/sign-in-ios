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
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    private func handleError(error: Error) {
        HUD.flash(.error)
        if let errorResponse = error as? ErrorResponse {
            print(errorResponse.error)
        }
    }
}
