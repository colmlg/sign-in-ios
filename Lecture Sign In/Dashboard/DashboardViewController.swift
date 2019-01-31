import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var refernceSwitch: UISwitch!
    
    private let disposeBag = DisposeBag()
    private let beaconManager = BeaconManager()
    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.faceImage.asObservable().bind(to: imageView.rx.image).disposed(by: disposeBag)
        beaconManager.delegate = self
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
        let controller = UIAlertController(title: "Faces Compared", message: text, preferredStyle: .alert)
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
            if self.refernceSwitch.isOn {
                self.viewModel.setImage(image: image)
            } else {
                self.viewModel.compareFaces(image: image, completion: { success in
                    self.showAlertDialog(text: success ? "Faces are Identical!" : "Not the same face!")
                })
            }
        })
        
    }
}

extension DashboardViewController: BeaconManagerDelegate {
    func closestBeaconDidChange(beacon: CLBeacon?) {
        guard let beacon = beacon else {
            roomNumberLabel.text = "Room Number: "
            return
        }
        roomNumberLabel.text = "Room Number: \(beacon.major), \(beacon.minor)"
    }
}
