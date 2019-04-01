import Foundation
import UIKit
import RxSwift
import RxCocoa

class AccountViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var studentNumberLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private let viewModel = AccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 45
        studentNumberLabel.text = viewModel.user?.studentNumber
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        viewModel.logout()
        performSegue(withIdentifier: "logout", sender: sender)
    }
}
