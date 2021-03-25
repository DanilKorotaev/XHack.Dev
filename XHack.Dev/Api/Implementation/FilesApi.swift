//
//  FilesApi.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 22.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import Foundation
import PromiseKit

class FilesApi: IFilesApi {
    
    private let endpointsProvider: ApiEndpoints
    private let apiTokenHolder: IApiTokensHolder
    
    init(endpointsProvider: ApiEndpoints,apiTokenHolder: IApiTokensHolder) {
        self.endpointsProvider = endpointsProvider
        self.apiTokenHolder = apiTokenHolder
    }
    
    func uploadFile(file: File) -> Promise<ApiResult<FileUrlResponse>> {
        let url = endpointsProvider.gatewayUrl + "/api/file-upload/single"
        return ApiHelpers.executeReliablySendFileRequest(apiTokenHolder: apiTokenHolder, url: url, file: file)
    }
    
//    private func upload(url: String, fileName: String, fileData: Data) {
//        let url = URL(string: url)
//
//        // generate boundary string using a unique per-app string
//        let boundary = UUID().uuidString
//
//        let session = URLSession.shared
//
//        // Set the URLRequest to POST and to the specified URL
//        var urlRequest = URLRequest(url: url!)
//        urlRequest.httpMethod = "POST"
//
//        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
//        // And the boundary is also set here
//        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var data = Data()
//
//        // Add the image data to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(fileData)
//
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//        // Send a POST request to the URL, with the data we created earlier
//        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//            if error == nil {
//                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
//                if let json = jsonData as? [String: Any] {
//                    print(json)
//                }
//            }
//        }).resume()
//    }

}
