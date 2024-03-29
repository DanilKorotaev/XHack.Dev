//
//  UIImage+Extension.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 26.12.2020.
//  Copyright © 2020 Wojciech Kulik. All rights reserved.
//

import Foundation
import UIKit

fileprivate var cashedImages: [String: UIImage] = [:]

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, placeholder: String? = nil) {
        contentMode = mode
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }
        if let image =  cashedImages[url.absoluteString] {
            self.image = image
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                cashedImages[url.absoluteString] = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeholder: String? = nil) {
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, placeholder: placeholder)
    }
}
