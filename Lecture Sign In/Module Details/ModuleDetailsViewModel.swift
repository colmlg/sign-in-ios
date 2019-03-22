import Foundation
import RxSwift

class ModuleDetailsViewModel {
    var moduleId: String!

    private let disposeBag = DisposeBag()
    private let service = ModuleService()
    private var lessons = [Lesson]()

    var overallAttendance = 0.0
    var lectureAttendance = 0.0
    var labAttendance = 0.0
    var tutorialAttendance = 0.0
    
    func getModuleDetails(id: String) {
        service.getModuleDetails(id: id).subscribe(onNext: { response in
            self.lessons = response.lessons
            self.calculateAttendanceStats()
        }).disposed(by: disposeBag)
    }
    
    func calculateAttendanceStats() {
        
    }
}
