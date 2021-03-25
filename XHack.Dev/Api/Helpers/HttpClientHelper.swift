//
//  HttpClientHelper.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 30.11.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class HttpClientHelper {
    
    private var httpClient: HttpClient
    
    public static let shared = HttpClientHelper()
    
    private init() {
        httpClient = HttpRequestExecutor()
    }
    
    
    func get(url: String, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Promise<Response<HTTPStatusCode, Data>> {
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
    
    
    func post(url: String, postData: Data? = nil, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Promise<Response<HTTPStatusCode, Data>>  {
        guard let url = URL(string: url) else { fatalError("Wrong url on \(String(describing: post))") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept":"application/json"]
        request.httpBody = postData
        if let postData = postData {
            let json = String(data: postData, encoding: .utf8)!
            print(json)
        }
       
        if let accessToken = accessToken {
            setBearerToken(accessToken, for: &request)
        }
        
        return createDataTask(request: request)
    }
    
    
    func patch(url: String, patchData: Data, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Promise<Response<HTTPStatusCode, Data>> {
        guard let url = URL(string: url) else { fatalError("Wrong url on \(String(describing: post))") }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept":"application/json"]
        request.httpBody = patchData
        let json = String(data: patchData, encoding: .utf8)!
        print(json)
        if let accessToken = accessToken {
            setBearerToken(accessToken, for: &request)
        }
        
        return createDataTask(request: request)
    }
    
    
    func delete(url: String, deleteData: Data, accessToken: String? = nil, requestHeaders: [String:String]? = nil) -> Promise<Response<HTTPStatusCode, Data>> {
        guard let url = URL(string: url) else { fatalError("Wrong url on \(String(describing: post))") }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Accept":"application/json"]
        request.httpBody = deleteData
        let json = String(data: deleteData, encoding: .utf8)!
        print(json)
        if let accessToken = accessToken {
            setBearerToken(accessToken, for: &request)
        }
        
        return createDataTask(request: request)
    }
    
    
    func sendFile(
        urlPath: String,
        fileName: String,
        data: Data) -> Promise<Response<HTTPStatusCode, Data>>  {

        let url: URL = URL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)

        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        let fullData = photoDataToFormData(data: data,boundary:boundary,fileName:fileName)

        request.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")

        // REQUIRED!
        request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")

        request.httpBody = fullData
        request.httpShouldHandleCookies = false
        
        return createDataTask(request: request as URLRequest)
    }

    private func photoDataToFormData(data:Data,boundary:String,fileName:String) -> Data {
        let fullData = NSMutableData()

        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
                            using: .utf8,
                            allowLossyConversion: false)!)

        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
                            using: .utf8,
                            allowLossyConversion: false)!)

        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
                            using: .utf8,
                            allowLossyConversion: false)!)

        fullData.append(data)

        let lineFive = "\r\n"
        fullData.append(lineFive.data(
                            using: .utf8,
                            allowLossyConversion: false)!)

        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
                            using:  .utf8,
                            allowLossyConversion: false)!)

        return fullData as Data
    }
    
    
    private func createDataTask(request: URLRequest) -> Promise<Response<HTTPStatusCode, Data>>  {
        return Promise() { promise in
            let dataTask = URLSession.shared.dataTask(with: request) { data,  response, error in
                let httpResponse = response as? HTTPURLResponse
                var dataString: String?
                if let data = data {
                    dataString = String(data: data, encoding: .utf8)
                    print(dataString!)
                }
                promise.fulfill(Response(status: httpResponse?.status ?? .serviceUnavailable, content: data))
            }
            print("Fetching \(request.url?.absoluteString ?? "")...")
            dataTask.resume()
        }
    }
    
    
    private func setBearerToken(_ token: String, for request: inout URLRequest) {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
