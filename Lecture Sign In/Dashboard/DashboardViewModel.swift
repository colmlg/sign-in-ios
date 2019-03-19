import RxSwift
import KeychainSwift
import PKHUD
import CoreLocation

//swiftlint:disable identifier_name
class DashboardViewModel {
    
    private let disposeBag = DisposeBag()
    
    var faceImage = Variable<UIImage?>(nil)
    var roomNumber = Variable<Int?>(nil)
    var roomLabel = Variable<String>("Room Number: ")
    
    init() {
        roomNumber.asObservable().subscribe(onNext: { newNumber in
            guard let key = newNumber, let room = Repository<Room>().findOne(key: key) else {
                return
            }
            
            self.roomLabel.value = "Room Number: " + room.roomNumber
            
        }).disposed(by: disposeBag)
    }
    
    func markAttendance(completion: @escaping (() -> Void), error: @escaping ((String) -> Void)) {
        guard let roomNumber = roomNumber.value, let image = faceImage.value else {
            error("No room number or image.")
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
        }, onError: { e in
            HUD.hide()
            let errorResponse = e as? ErrorResponse
            error(errorResponse?.error ?? "")
        }).disposed(by: disposeBag)
        
    }
    
    func getRooms() {
        RoomService().getRooms().subscribe(onNext: { rooms in
            Repository<Room>().saveAll(rooms)
            print("Saving room numbers in database...")
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
    }
}

extension DashboardViewModel: BeaconManagerDelegate {
    func closestBeaconDidChange(beacon: CLBeacon?) {
        guard let beacon = beacon else {
            roomLabel.value = "Room Number: "
            return
        }
        
        guard let number = Int("\(beacon.minor)") else {
            return
        }
        
        roomNumber.value = number
    }
}
