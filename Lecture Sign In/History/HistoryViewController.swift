import Foundation
import UIKit
import RxSwift
import RxCocoa

class HistoryViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = HistoryViewModel()
    private let cellIdentifier = "HistoryTableViewCellIdentifier"
    private var selectedModuleId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setModules {
            self.tableView.reloadData()
        }
        navigationItem.title = "My Modules"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = viewModel.modules[indexPath.row].id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedModuleId = viewModel.modules[indexPath.row].id
        performSegue(withIdentifier: "goToModuleDetails", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVc = segue.destination as? ModuleDetailsViewController else {
            return
        }
        
        detailsVc.moduleId = selectedModuleId
    }
}
