import RxSwift
import KeychainSwift
import PKHUD

class DashboardViewModel {
    
    private let disposeBag = DisposeBag()
    
    var faceImage = Variable<UIImage?>(nil)
    var roomNumber = Variable<String?>(nil)
    
    func markAttendance(completion: @escaping (() -> Void)) {
        guard let roomNumber = roomNumber.value, let image = faceImage.value else {
            return
        }
        
        let resizedImage = image.resizeImage(500.0, opaque: true)
        
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.5) else {
            return
        }
        HUD.show(.progress)
        let request = AttendanceRequest(roomNumber: roomNumber, image: imageData)
        
        AttendanceService().markAttendance(model: request).subscribe(onNext: { _ in
            HUD.flash(.success)
            completion()
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
        
    }
}
