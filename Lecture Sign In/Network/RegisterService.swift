import RxSwift

class RegisterService {
    func register(model: RegisterRequest) -> Observable<TokenResponse?> {
        return APIManager.shared.post(model: model, endPoint: "/register")
    }
}
