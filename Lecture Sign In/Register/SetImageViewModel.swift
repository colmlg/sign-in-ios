import Foundation
import RxSwift
import PKHUD

class SetImageViewModel {
    private let disposeBag = DisposeBag()
    let faceImage = Variable<UIImage?>(nil)
    
    func setImage(completion: @escaping () -> Void) {
        let resizedImage = faceImage.value!.resizeImage(500.0, opaque: true)
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.5) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        HUD.show(.progress)
        UserService().setImage(model: request).subscribe(onNext: { _ in
            HUD.flash(.success)
            completion()
        }, onError: handleError).disposed(by: disposeBag)
    }
    
    func handleError(_ error: Error) {
        HUD.flash(.error)
        let errorResponse = error as? ErrorResponse
        print(errorResponse?.error)
    }
}
