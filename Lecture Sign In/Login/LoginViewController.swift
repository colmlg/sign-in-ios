import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        viewModel.login {
            self.performSegue(withIdentifier: "login", sender: sender)
        }
    }
}
