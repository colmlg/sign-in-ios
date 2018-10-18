import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private let disposeBag = DisposeBag()
    private let beaconManager = BeaconManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: BeaconManagerDelegate {
    func closestBeaconDidChange(beacon: CLBeacon?) {
        guard let beacon = beacon else {
            roomNumberLabel.text = "Room Number: "
            return
        }
        roomNumberLabel.text = "Room Number: \(beacon.major), \(beacon.minor)"
    }
}
