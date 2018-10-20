import RxSwift
import KeychainSwift

class DashboardViewModel {
    
    private let disposeBag = DisposeBag()
    
    var faceImage = Variable<UIImage?>(nil)
    var roomNumber = Variable<String?>(nil)
    
    func login() {
        let user = LoginRequest(id: "15148823", password: "Password1")
        
        LoginService().login(request: user).subscribe(onNext: { tokenResponse in
            KeychainSwift().set(tokenResponse.token, forKey: "Access Token")
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
