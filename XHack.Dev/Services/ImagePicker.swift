//
//  ImagePicker.swift
//  XHack.Dev
//
//  Created by Данил Коротаев on 21.03.2021.
//  Copyright © 2021 Wojciech Kulik. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerDelegate: class {
    func didSelect(file: File?)
}

class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect file: File?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(file: file)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var fileName: String = ""
        var fileSize: Int = 0
        if let filePath = info[.referenceURL] as? URL {
            fileName = filePath.lastPathComponent
            fileName = String((fileName.split(separator: ".").first ?? "") + ".jpg")
        }
        
        if let filePath = info[.imageURL] as? URL {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: filePath.path)
                fileSize = Int(attr[.size] as! UInt64)
            } catch {
            }
        }
        
        guard let image = info[.editedImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 1) else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: File(name: fileName, size: fileSize, data: imageData))
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}

