import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    let studentId = Variable<String>("")
    let password = Variable<String>("")
    let confirmPassword = Variable<String>("")
    
    let shouldEnableButton: Observable<Bool>
    
    init() {
        shouldEnableButton = Observable.combineLatest(studentId.asObservable(), password.asObservable(), confirmPassword.asObservable()) { id, password, confirmPassword in
            let notEmpty = !id.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
            let passwordsMatch = password == confirmPassword
            let idMatches = id.
        }
    }
}
