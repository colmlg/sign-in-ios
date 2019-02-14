import Foundation
import Alamofire
import RxSwift
import KeychainSwift

class BaseAPIService {
    private let baseUrl = "http://afe225a7.ngrok.io"
    
    func post<T: Codable>(model: Codable, endPoint: String) -> Observable<T> {
        guard let url = URL(string: self.baseUrl + endPoint) else {
            return Observable.error(ErrorResponse(error: "Invalid URL"))
        }
        let request = self.buildRequest(url: url, method: .post, body: model.toData())
        return sendRequest(request: request)
    }
    
    private func sendRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable.create { observer in
            Alamofire.request(request).response { (response) in
                
                if let status = response.response?.statusCode, status != 200 {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                    return observer.onError(errorResponse ?? ErrorResponse(error: "Inavlid Response"))
                }
                
                guard let data = response.data,
                    let responseModel = try? JSONDecoder().decode(T.self, from: data) else {
                        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                        return observer.onError(errorResponse ?? ErrorResponse(error: "Inavlid Response"))
                }
                
                observer.onNext(responseModel)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func buildRequest(url: URL, method: HTTPMethod, body: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        if let token = KeychainSwift().get("Access Token") {
            request.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        return request
    }
}
