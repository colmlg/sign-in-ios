import Foundation
import RxSwift

class HistoryViewModel {
    var modules = [Module]()
    
    private let service = ModuleService()
    private let disposeBag = DisposeBag()
    
    func setModules(completion: @escaping () -> Void) {
        service.getModules().subscribe(onNext: { modules in
            self.modules = modules
            completion()
        }).disposed(by: disposeBag)
    }
}
