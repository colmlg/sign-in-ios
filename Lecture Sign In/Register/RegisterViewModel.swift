import Foundation
import RxSwift
import PKHUD
import KeychainSwift

class RegisterViewModel {
    private let disposeBag = DisposeBag()
    let studentId = Variable<String>("")
    let password = Variable<String>("")
    let confirmPassword = Variable<String>("")
    let shouldEnableButton: Observable<Bool>
    
    init() {
        shouldEnableButton = Observable.combineLatest(studentId.asObservable(),
                                                      password.asObservable(),
                                                      confirmPassword.asObservable()) { studentId, password, confirmPassword in
            let notEmpty = !studentId.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
            let passwordsMatch = password == confirmPassword
            let idMatches = studentId.matches(regex: "[0-9]{7,8}")
            return notEmpty && passwordsMatch && idMatches
        }
    }
    
    func register(completion: @escaping () -> Void) {
        let request = RegisterRequest(id: studentId.value, password: password.value)
        RegisterService().register(model: request).subscribe(onNext: { response in
            KeychainSwift().set(response.token, forKey: "Access Token")
            completion()
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    //TODO: Put this function in some shared location. Also, display more descriptive error messages.
    private func handleError(error: Error) {
        HUD.flash(.error)
        if let errorResponse = error as? ErrorResponse {
            print(errorResponse.error)
        }
    }
}
