import Foundation
import RxSwift
import SwiftDate

class ModuleDetailsViewModel {
    var moduleId: String!
    var overallAttendance = Variable<Double>(0.0)
    var lectureAttendance = Variable<Double>(0.0)
    var labAttendance = Variable<Double>(0.0)
    var tutorialAttendance = Variable<Double>(0.0)
    
    let hideLecs = Variable<Bool>(true)
    let hideLabs = Variable<Bool>(true)
    let hideTuts = Variable<Bool>(true)
    
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
        calculateLectureStats()

        let tutorials = lessons.filter({$0.type == "TUT"})
        hideTuts.value = tutorials.count == 0
        tutorialAttendance.value = calculateLabAndTutStats(lessons: tutorials)
        
        let labs = lessons.filter({$0.type == "LAB"})
        hideLabs.value = labs.count == 0
        labAttendance.value = calculateLabAndTutStats(lessons: labs)
        
        calculateOverallStats()
        
    }
    
    private func calculateOverallStats() {
        var sum = 0.0
        var counter = 0.0
        
        if !hideLecs.value {
            sum += lectureAttendance.value
            counter += 1
        }
        
        if !hideLabs.value {
            sum += labAttendance.value
            counter += 1
        }
        
        if !hideTuts.value {
            sum += tutorialAttendance.value
            counter += 1
        }
        
        overallAttendance.value = sum / counter
    }
    
    private func calculateLectureStats() {
        let lectures = lessons.filter({$0.type == "LEC"})
        hideLecs.value = lectures.count == 0
        let totalLectures = lectures.count
        let lecturesAttended = lectures.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        let attendance = (Double(lecturesAttended) / Double(totalLectures) ) * 100.0
        lectureAttendance.value = attendance <= 100.0 ? attendance : 100.0
    }
    
    private func calculateLabAndTutStats(lessons: [Lesson]) -> Double {
        var lessonsCopy = lessons
        
        for _ in 0..<lessonsCopy.count {
            let lesson = lessonsCopy.remove(at: 0)
            lessonsCopy = lessonsCopy.filter({!Date($0.date)!.isInside(date: Date(lesson.date)!, granularity: .weekOfYear)})
            lessonsCopy.append(lesson)
        }
        let goalNumber = lessonsCopy.count //1 lesson per week
        
        let lessonsAttended = lessons.filter({$0.studentsAttended.contains(user.studentNumber)}).count
        let attendance = (Double(lessonsAttended) / Double(goalNumber) ) * 100.0
        
        if attendance > 100.0 {
            return 100.0
        } else if attendance.isNaN {
            return 0.0
        } else {
            return attendance
        }
    }
}
