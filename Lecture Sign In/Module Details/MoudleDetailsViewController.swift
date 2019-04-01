import Foundation
import UIKit
import RxSwift
import PKHUD
import UICircularProgressRing

class ModuleDetailsViewController: UIViewController {
    @IBOutlet weak var overallRing: UICircularProgressRing!
    @IBOutlet weak var lecturesRing: UICircularProgressRing!
    @IBOutlet weak var labsRing: UICircularProgressRing!
    @IBOutlet weak var tutorialsRing: UICircularProgressRing!
    @IBOutlet weak var lecturesLabel: UILabel!
    @IBOutlet weak var labsLabel: UILabel!
    @IBOutlet weak var tutorialsLabel: UILabel!
    
    private let viewModel = ModuleDetailsViewModel()
    private let disposeBag = DisposeBag()
    var moduleId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = moduleId
        initObservers()
        initBindings()
        HUD.show(.progress)
        viewModel.getModuleDetails(id: moduleId)
    }
    
    private func initBindings() {
        viewModel.hideLecs.asObservable().bind(to: lecturesRing.rx.isHidden).disposed(by: disposeBag)
        viewModel.hideLecs.asObservable().bind(to: lecturesLabel.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.hideTuts.asObservable().bind(to: tutorialsRing.rx.isHidden).disposed(by: disposeBag)
        viewModel.hideTuts.asObservable().bind(to: tutorialsLabel.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.hideLabs.asObservable().bind(to: labsRing.rx.isHidden).disposed(by: disposeBag)
        viewModel.hideLabs.asObservable().bind(to: labsLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func initObservers() {
        viewModel.overallAttendance.asObservable().subscribe(onNext: { overall in
            self.set(value: overall, on: self.overallRing)
        }).disposed(by: disposeBag)
        
        viewModel.lectureAttendance.asObservable().subscribe(onNext: { lecture in
            self.set(value: lecture, on: self.lecturesRing)
        }).disposed(by: disposeBag)
        
        viewModel.labAttendance.asObservable().subscribe(onNext: { lab in
            self.set(value: lab, on: self.labsRing)
        }).disposed(by: disposeBag)
        
        viewModel.tutorialAttendance.asObservable().subscribe(onNext: { tutorial in
            self.set(value: tutorial, on: self.tutorialsRing)
        }).disposed(by: disposeBag)
    }
    
    private func set(value: Double, on progressRing: UICircularProgressRing) {
        HUD.hide()
        progressRing.startProgress(to: CGFloat(value), duration: 1.0)
        if value >= 75 {
            progressRing.innerRingColor = UIColor(named: "Success")!
        } else if value >= 50 {
            progressRing.innerRingColor = UIColor(named: "Warning")!
        } else {
            progressRing.innerRingColor = UIColor(named: "Danger")!
        }
    }
}
