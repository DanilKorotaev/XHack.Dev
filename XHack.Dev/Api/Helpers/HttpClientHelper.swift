//
//  HttpClientHelper.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift

class HttpClientHelper {
    
    private var httpClient: HttpClient
    
    public static let shared = HttpClientHelper()
    
    private init() {
        httpClient = HttpRequestExecutor()
    }
    
    
    func get(url: String, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Observable<Response<HTTPStatusCode, Data>> {
//        let uniqueId = UUID()
//        let identity = "\(uniqueId)"
        guard let url = URL(string: url) else { fatalError("Wrong url on \(String(describing: get))") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = requestHeaders
        
        if let accessToken = accessToken {
            setBearerToken(accessToken, for: &request)
        }
        return createDataTask(request: request)
    }
    
    func post(url: String, postData: Data, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Observable<Response<HTTPStatusCode, Data>>  {
        guard let url = URL(string: url) else { fatalError("Wrong url on \(String(describing: post))") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept":"application/json"]
        request.httpBody = postData
        let json = String(data: postData, encoding: .utf8)!
        print(json)
        if let accessToken = accessToken {
            setBearerToken(accessToken, for: &request)
        }
        
        return createDataTask(request: request)
    }
    
    
    private func createDataTask(request: URLRequest) -> Observable<Response<HTTPStatusCode, Data>>  {
        return Observable.create { (observer) -> Disposable in
            let dataTask = URLSession.shared.dataTask(with: request) { data,  response, error in
                let httpResponse = response as? HTTPURLResponse
                var dataString: String?
                if let data = data {
                    dataString = String(data: data, encoding: .utf8)
                    print(dataString!)
                }
                observer.onNext(Response(status: httpResponse?.status ?? .serviceUnavailable, content: data))
            }
            print("Fetching \(request.url?.absoluteString ?? "")...")
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
    
    private func setBearerToken(_ token: String, for request: inout URLRequest) {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
