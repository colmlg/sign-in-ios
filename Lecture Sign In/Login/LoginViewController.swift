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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isUserLoggedIn {
            performSegue(withIdentifier: "login", sender: viewModel)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        viewModel.login { isImageSet in
            let segueId = isImageSet ? "login" : "setImage"
            self.performSegue(withIdentifier: segueId, sender: sender)
        }
    }
}
