import RxSwift
import KeychainSwift

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
        let resizedImage = image.resizeImage(400.0, opaque: true)
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.5) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        UserService().setImage(model: request).subscribe(onNext: { _ in
            print("Success!")
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func handleError(_ error: Error) {
        print(error.localizedDescription)
    }
}
