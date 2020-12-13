//import Foundation
//import RxSwift
//
//class BackendRestClient: RestClient {
//    private let httpClient: HttpClient
//    private let alertDispatcher: AlertDispatcher
//    private lazy var sessionService: SessionService? = AppDelegate.container.resolve(SessionService.self)
//
//    private var token: String? {
//        return sessionService?.sessionState?.token.accessToken
//    }
//
//    init(httpClient: HttpClient, alertDispatcher: AlertDispatcher) {
//        self.httpClient = httpClient
//        self.alertDispatcher = alertDispatcher
//    }
//
//    func request<T:Codable>(_ request: ApiRequest<T>) -> Single<T>{
//        return Single.create { [weak self] single in
//            guard let self = self else { return Disposables.create() }
//
//            self.httpClient.set(headers: self.getHeaders())
//            self.httpClient.request(
//                resource: request.resource,
//                method: request.method,
//                json: request.json)
//            {
//                self.validate(response: $0, for: request, single: single)
//            }
//
//            return Disposables.create()
//        }
//    }
//
//    private func validate<T:Codable>(response: ApiResponse, for request: ApiRequest<T>, single: Single<T>.SingleObserver) {
//        response.print()
//
//        guard response.success else {
//            Logger.error("Unsuccessful request", error: response.error)
//            let error = ApiError.requestFailed(statusCode: response.statusCode, response: response.data)
//            dispatch(error: error)
//            single(.error(error))
//            return
//        }
//
//        guard let parsedResponse = response.data?.toObject(T.self) else {
//            Logger.error("Could not parse response")
//            let error = ApiError.requestFailed(statusCode: response.statusCode, response: response.data)
//            dispatch(error: error)
//            single(.error(error))
//            return
//        }
//
//        single(.success(parsedResponse))
//    }
//
//    private func getHeaders() -> [String:String] {
//        var headers = ["Content-Type": "application/json"]
//        if let tokenHeader = token {
//            headers["Authorization"] = "Bearer \(tokenHeader)"
//        }
//        return headers
//    }
//
//    private func dispatch(error: ApiError) {
//        let message = getMessage(error: error)
//        alertDispatcher.dispatch(error: message)
//    }
//
//    private func getMessage(error: ApiError) -> AlertMessage {
//        var message = "Could not process request."
//
//        if case .requestFailed(_, let response) = error,
//            let errorResponse = response?.toObject(ErrorResponse.self)?.errorCode?.localized {
//            message = errorResponse
//        }
//
//        let alertMessage = AlertMessage(title: "Error", message: message, buttons: ["OK"], actions: [:])
//        return alertMessage
//    }
//}
