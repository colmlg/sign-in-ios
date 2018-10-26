import RxSwift
import KeychainSwift
import PKHUD

class DashboardViewModel {
    
    private let disposeBag = DisposeBag()
    
    var faceImage = Variable<UIImage?>(nil)
    var roomNumber = Variable<String?>(nil)
    
    func login() {
        let user = LoginRequest(id: "student", password: "Password1")
        
        LoginService().login(request: user).subscribe(onNext: { tokenResponse in
            KeychainSwift().set(tokenResponse.token, forKey: "Access Token")
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func upload(image: UIImage) {
        let resizedImage = image.resizeImage(700.0, opaque: true)
        guard let imageData = UIImagePNGRepresentation(resizedImage) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        HUD.show(.progress)
        UserService().setImage(model: request).subscribe(onNext: { _ in
            HUD.flash(.success)
            print("Success!")
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func handleError(_ error: Error) {
        HUD.flash(.error)
        print(error.localizedDescription)
    }
}
