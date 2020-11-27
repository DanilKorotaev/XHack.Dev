
import Foundation
import RxSwift

protocol RestClient {
    func request<T:Codable>(_ request: ApiRequest<T>) -> Single<T>
}
