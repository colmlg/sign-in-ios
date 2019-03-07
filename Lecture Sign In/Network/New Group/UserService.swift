import RxSwift

class UserService: BaseAPIService {
    
    func setImage(model: ImageRequest) -> Observable<EmptyResponse> {
        return post(model: model, endPoint: "/user/image")
    }
}
