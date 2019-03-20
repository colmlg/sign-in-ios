import Foundation
import Alamofire
import RxSwift
import KeychainSwift

class BaseAPIService {
    private let baseUrl = "http://2c504365.ngrok.io"
    
    func post<T: Codable>(model: Codable, endPoint: String) -> Observable<T> {
       return makeRequest(endPoint: endPoint, method: .post, body: model.toData())
    }
    
    func get<T: Codable>(endPoint: String) -> Observable<T> {
        return makeRequest(endPoint: endPoint, method: .get)
    }
    
    private func makeRequest<T: Codable>(endPoint: String, method: HTTPMethod, body: Data? = nil) -> Observable<T> {
        guard let url = URL(string: self.baseUrl + endPoint) else {
            return Observable.error(ErrorResponse(error: "Invalid URL"))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        if let token = KeychainSwift().get("Access Token") {
            request.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        return sendRequest(request: request)
    }
    
    private func sendRequest<T: Codable>(request: URLRequest) -> Observable<T> {
        return Observable.create { observer in
            Alamofire.request(request).response { (response) in
                
                if let status = response.response?.statusCode, status != 200 {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                    return observer.onError(errorResponse ?? ErrorResponse(error: "Inavlid Response status \(status)"))
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
}
