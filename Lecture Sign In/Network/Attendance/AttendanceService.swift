import RxSwift

class AttendanceService: BaseAPIService {
    func markAttendance(model: AttendanceRequest) -> Observable<EmptyResponse> {
        return post(model: model, endPoint: "/attendance/student")
    }
}
