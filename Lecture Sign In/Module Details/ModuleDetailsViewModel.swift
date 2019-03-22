import Foundation
import RxSwift
import SwiftDate

class ModuleDetailsViewModel {
    var moduleId: String!

    private let disposeBag = DisposeBag()
    private let service = ModuleService()
    private var lessons = [Lesson]()
    private let user: User!
    var overallAttendance = 0.0
    var lectureAttendance = 0.0
    var labAttendance = 0.0
    var tutorialAttendance = 0.0
    
    init() {
        user = Repository<User>().findOne(key: "User")
    }
    
    func getModuleDetails(id: String) {
        service.getModuleDetails(id: id).subscribe(onNext: { response in
            self.lessons = response.lessons
            self.calculateAttendanceStats()
        }).disposed(by: disposeBag)
    }
    
    private func calculateAttendanceStats() {
        calculateLectureAttendanceStats()
        calculateLabAttendanceStats()
        calculateTutorialAttendanceStats()
        overallAttendance = (lectureAttendance + labAttendance + tutorialAttendance) / 3
    }
    
    private func calculateLectureAttendanceStats() {
        let lectures = lessons.filter({$0.type == "LEC"})
        let totalLectures = lectures.count
        let lecturesAttended = lectures.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        lectureAttendance = (Double(lecturesAttended) / Double(totalLectures) ) * 100.0
    }

    private func calculateLabAttendanceStats() {
        let labs = lessons.filter({$0.type == "LAB"})
        var labsCopy = labs
        
        for _ in 0..<labsCopy.count {
            let lab = labsCopy.remove(at: 0)
            labsCopy = labsCopy.filter({$0.date.isInside(date: lab.date, granularity: .weekOfYear)})
            labsCopy.append(lab)
        }
        let goalNumber = labsCopy.count
        
        let labsAttended = labs.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        labAttendance = (Double(labsAttended) / Double(goalNumber) ) * 100.0
    }
    
    private func calculateTutorialAttendanceStats() {
        let tutorials = lessons.filter({$0.type == "TUT"})
        var tutsCopy = tutorials
        
        for _ in 0..<tutsCopy.count {
            let tut = tutsCopy.remove(at: 0)
            tutsCopy = tutsCopy.filter({$0.date.isInside(date: tut.date, granularity: .weekOfYear)})
            tutsCopy.append(tut)
        }
        let goalNumber = tutsCopy.count
        
        let tutsAttended = tutorials.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        tutorialAttendance = (Double(tutsAttended) / Double(goalNumber) ) * 100.0
    }
}
