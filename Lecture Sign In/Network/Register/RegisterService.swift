import RxSwift

class RegisterService: BaseAPIService {
    func register(model: RegisterRequest) -> Observable<TokenResponse> {
        return post(model: model, endPoint: "/register")
    }
}
