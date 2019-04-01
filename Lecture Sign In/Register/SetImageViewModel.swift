import Foundation
import RxSwift
import PKHUD

class SetImageViewModel {
    private let disposeBag = DisposeBag()
    let faceImage = Variable<UIImage>(#imageLiteral(resourceName: "vectorpaint"))
    
    func setImage(completion: @escaping () -> Void) {
        let resizedImage = faceImage.value.resizeImage(500.0, opaque: true)
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let request = ImageRequest(image: imageData)
        HUD.show(.progress)
        UserService().setImage(model: request).subscribe(onNext: { _ in
            HUD.flash(.success)
            completion()
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
    }
}
