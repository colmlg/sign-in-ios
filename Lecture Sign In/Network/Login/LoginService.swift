import RxSwift

class LoginService: BaseAPIService {
    
    func login(request: LoginRequest) -> Observable<TokenResponse> {
        return post(model: request, endPoint: "/login")
    }
}
