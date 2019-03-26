import Foundation
import UIKit
import RxSwift

class SetImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private let viewModel = SetImageViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.faceImage.asObservable().bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
    
    @IBAction func openCameraButtonPressed(_ sender: Any) {
        openCamera()
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showConfirmImageDialog() {
        let controller = UIAlertController(title: "Image Captured", message: "Are you happy with this image?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            self.openCamera()
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.setImage {
                self.performSegue(withIdentifier: "dashboard", sender: nil)
            }
        }
        
        controller.addAction(noAction)
        controller.addAction(yesAction)
        present(controller, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }
        dismiss(animated: true, completion: {
            self.viewModel.faceImage.value = image
            self.showConfirmImageDialog()
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
