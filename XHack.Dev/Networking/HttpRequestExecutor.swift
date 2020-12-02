import Foundation

class HttpRequestExecutor: HttpClient {
    private var headers: [String : String]?
    
    func set(headers: [String : String]) {
        self.headers = headers
    }
    
    func request(resource: String, method: HttpMethod, json: Data?, completion: @escaping (ApiResponse) -> Void) {
        guard let url = URL(string: resource) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = json
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data,  response, error in
            let httpResponse = response as? HTTPURLResponse
            let success = httpResponse != nil ?  200 ... 299 ~= httpResponse!.statusCode : false
            let result = ApiResponse(success: success, statusCode: httpResponse?.statusCode, requestUrl: resource, method: method, data: data, error: error)
            completion(result)
        }
        print("Fetching \(request.url?.absoluteString ?? "")...")
        dataTask.resume()
    }
    
    func setBearerToken(_ token: String) {
        
    }
}
