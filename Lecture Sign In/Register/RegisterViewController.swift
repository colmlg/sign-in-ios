import Foundation
import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var studentIdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        studentIdField.rx.text.orEmpty.bind(to: viewModel.studentId).disposed(by: disposeBag)
        passwordField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        confirmPasswordField.rx.text.orEmpty.bind(to: viewModel.confirmPassword).disposed(by: disposeBag)
        viewModel.shouldEnableButton.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1212944761, green: 0.1292245686, blue: 0.141699791, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        viewModel.register {
            self.performSegue(withIdentifier: "goToSetImage", sender: nil)
        }
    }
}
