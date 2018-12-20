//
//  UpdatePhotoVC.swift
//  SaveImageOutsideRealm
//
//  Created by David E Bratton on 12/17/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class UpdatePhotoVC: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoText: UITextField!
    
    var passedPhoto: Photo?
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard2()
        pickerController.delegate = self
        if let photo = passedPhoto {
            photoText.text = photo.photoDescription
            let path = photo.photoPath
            print("Update Img Path: \(path)")
            var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsPath = paths[0]
            let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(photo.photoPath).path
            photoImageView.image = UIImage(contentsOfFile: filePath)
        }
    }
    
    @IBAction func mediaBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true) {
        }
    }
    
    @IBAction func updatePhotoBtnPressed(_ sender: UIBarButtonItem) {
        if let photo = passedPhoto {
            let imageData = photoImageView.image?.jpegData(compressionQuality: 0.5)
            let uuid = "\(photo.photoPath)"
            let fileName = uuid.replacingOccurrences(of: "ImagesFolder/", with: "")
            let folderName = "ImagesFolder"
            saveImageToDirectory(imageData: imageData!, fileName: fileName, folderName: folderName)
        }
    }
    
    func saveImageToDirectory(imageData: Data, fileName: String, folderName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(folderName) as NSString
        if !FileManager.default.fileExists(atPath: path as String) {
            do {
                try FileManager.default.createDirectory(atPath: path as String, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        let imagePath = path.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: imagePath as String) {
            try? imageData.write(to: URL(fileURLWithPath: imagePath))
        } else if FileManager.default.fileExists(atPath: imagePath as String) {
            try? imageData.write(to: URL(fileURLWithPath: imagePath))
        }
        if let photo = passedPhoto {
            let newPhoto = Photo()
            newPhoto.photoID = photo.photoID
            if let description = photoText.text {
                newPhoto.photoDescription = description
            }
            let photoPath = "ImagesFolder/\(fileName)"
            newPhoto.photoPath = photoPath
            RealmHelper.updatePhoto(photo: newPhoto)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension UpdatePhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboard2()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard2))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard2()
    {
        view.endEditing(true)
    }
}
