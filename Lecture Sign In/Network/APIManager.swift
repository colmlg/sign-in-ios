import Foundation
import Alamofire
import RxSwift

protocol DataConvertable: Codable {
    func toData() -> Data?
}

extension DataConvertable {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

class APIManager {
    
    private let baseUrl = "http://localhost:3000"
    static let shared = APIManager()
    
    func post<T: Codable>(model: DataConvertable, endPoint: String) -> Observable<T?> {
        let url = URL(string: self.baseUrl + endPoint)!
        let request = self.buildRequest(url: url, method: .post, body: model.toData())
        return sendRequest(request: request)
    }
    
    private func sendRequest<T: Codable>(request: URLRequest) -> Observable<T?> {
        return Observable.create { observer in
            Alamofire.request(request).response { (response) in
                let responseModel = try? JSONDecoder().decode(T.self, from: response.data!)
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
        return request
    }
}
