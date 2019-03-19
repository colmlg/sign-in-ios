import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var markAttendanceButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let beaconManager = BeaconManager()
    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.roomLabel.asObservable().bind(to: roomNumberLabel.rx.text).disposed(by: disposeBag)
        viewModel.getRooms()
        beaconManager.delegate = viewModel
        beaconManager.startMonitoring()
    }
    
    @IBAction func openCameraPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showAlertDialog(text: String) {
        let controller = UIAlertController(title: "Request Complete", message: text, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okayButton)
        show(controller, sender: nil)
    }
}

extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        viewModel.faceImage.value = image
        dismiss(animated: true, completion: {
            self.viewModel.markAttendance(completion: {
                self.showAlertDialog(text: "Successfully marked attendance")
            }, error: { errorMessage in
                self.showAlertDialog(text: errorMessage)
            })
        })
        
    }
}
