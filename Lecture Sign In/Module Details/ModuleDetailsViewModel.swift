import Foundation
import RxSwift
import SwiftDate

class ModuleDetailsViewModel {
    var moduleId: String!
    var overallAttendance = Variable<Double>(0.0)
    var lectureAttendance = Variable<Double>(0.0)
    var labAttendance = Variable<Double>(0.0)
    var tutorialAttendance = Variable<Double>(0.0)
    
    private let disposeBag = DisposeBag()
    private let service = ModuleService()
    private var lessons = [Lesson]()
    private let user: User!

    init() {
        user = Repository<User>().findOne(key: "User")
    }
    
    func getModuleDetails(id: String) {
        service.getModuleDetails(id: id).subscribe(onNext: { response in
            self.lessons = response.lessons
            self.calculateAttendanceStats()
        }, onError: ErrorHandler.handleError).disposed(by: disposeBag)
    }
    
    private func calculateAttendanceStats() {
        calculateLectureAttendanceStats()
        calculateLabAttendanceStats()
        calculateTutorialAttendanceStats()
        overallAttendance.value = (lectureAttendance.value + labAttendance.value + tutorialAttendance.value) / 3
    }
    
    private func calculateLectureAttendanceStats() {
        let lectures = lessons.filter({$0.type == "LEC"})
        let totalLectures = lectures.count
        let lecturesAttended = lectures.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        let attendance = (Double(lecturesAttended) / Double(totalLectures) ) * 100.0
        lectureAttendance.value = attendance <= 100.0 ? attendance : 100.0
    }

    private func calculateLabAttendanceStats() {
        let labs = lessons.filter({$0.type == "LAB"})
        var labsCopy = labs
        
        for _ in 0..<labsCopy.count {
            let lab = labsCopy.remove(at: 0)
            labsCopy = labsCopy.filter({!Date($0.date)!.isInside(date: Date(lab.date)!, granularity: .weekOfYear)})
            labsCopy.append(lab)
        }
        let goalNumber = labsCopy.count
        
        let labsAttended = labs.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        let attendance = (Double(labsAttended) / Double(goalNumber) ) * 100.0
        labAttendance.value = attendance <= 100.0 ? attendance : 100.0
    }
    
    private func calculateTutorialAttendanceStats() {
        let tutorials = lessons.filter({$0.type == "TUT"})
        var tutsCopy = tutorials
        
        for _ in 0..<tutsCopy.count {
            let tut = tutsCopy.remove(at: 0)
            tutsCopy = tutsCopy.filter({!Date($0.date)!.isInside(date: Date(tut.date)!, granularity: .weekOfYear)})
            tutsCopy.append(tut)
        }
        let goalNumber = tutsCopy.count
        
        let tutsAttended = tutorials.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        let attendance = (Double(tutsAttended) / Double(goalNumber) ) * 100.0
        tutorialAttendance.value = attendance <= 100.0 ? attendance : 100.0
    }
}
