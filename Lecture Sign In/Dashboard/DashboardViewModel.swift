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
    
    func setImage(image: UIImage) {
        let resizedImage = image.resizeImage(500.0, opaque: true)
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.5) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        HUD.show(.progress)
        UserService().setImage(model: request).subscribe(onNext: { _ in
            HUD.flash(.success)
            print("Success!")
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func compareFaces(image: UIImage, completion: @escaping ((Bool) -> Void)) {
        let resizedImage = image.resizeImage(500.0, opaque: true)
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.5) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        HUD.show(.progress)
        UserService().compareFaces(model: request).subscribe(onNext: { response in
            HUD.flash(.success)
            print(response.isIdentical)
            print(response.confidence)
            completion(response.isIdentical)
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func handleError(_ error: Error) {
        HUD.flash(.error)
        let errorResponse = error as? ErrorResponse
        print(errorResponse?.error)
    }
}
