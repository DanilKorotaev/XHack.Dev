import Foundation
import RxSwift

protocol HttpClient {
    func set(headers: [String:String])
    func request(resource: String, method: HttpMethod, json: Data?,
                 completion: @escaping (ApiResponse) -> Void) 
}
