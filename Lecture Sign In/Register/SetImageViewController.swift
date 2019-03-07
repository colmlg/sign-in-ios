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
}

extension SetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        dismiss(animated: true, completion: {
            self.viewModel.faceImage.value = image
            self.showConfirmImageDialog()
        })
    }
}
