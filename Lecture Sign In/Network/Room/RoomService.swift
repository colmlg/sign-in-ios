import RxSwift

class RoomService: BaseAPIService {
    func getRooms() -> Observable<[Room]> {
        return get(endPoint: "/room")
    }
}
