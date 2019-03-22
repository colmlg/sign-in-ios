import Foundation
import UIKit
import RxSwift

class ModuleDetailsViewController: UIViewController {
    
    let viewModel = ModuleDetailsViewModel()
    var moduleId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = moduleId
        viewModel.getModuleDetails(id: moduleId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
