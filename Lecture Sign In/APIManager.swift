import Foundation
import Alamofire

class APIManager {
    private let baseUrl = "http://localhost:3000"
    
    func post(model: Codable, endPoint: String) {
        //Alamofire.request(baseUrl + endPoint, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
    }
}
