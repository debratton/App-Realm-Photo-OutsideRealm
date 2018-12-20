//
//  AddPhotoVC.swift
//  SaveImageOutsideRealm
//
//  Created by David E Bratton on 12/17/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class AddPhotoVC: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoText: UITextField!
    
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        pickerController.delegate = self
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
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        let imageData = photoImageView.image?.jpegData(compressionQuality: 0.5)
        let uuid = UUID().uuidString
        let fileName = "\(uuid).jpg"
        let folderName = "ImagesFolder"
        saveImageToDirectory(imageData: imageData!, fileName: fileName, folderName: folderName)
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
        print("SAVE PATH")
        print(imagePath as Any)
        if !FileManager.default.fileExists(atPath: imagePath as String) {
            try? imageData.write(to: URL(fileURLWithPath: imagePath))
        }
        let newPhoto = Photo()
        if let description = photoText.text {
            newPhoto.photoDescription = description
        }
        let photoPath = "ImagesFolder/\(fileName)"
        newPhoto.photoPath = photoPath
        RealmHelper.savePhoto(photo: newPhoto)
        navigationController?.popViewController(animated: true)
    }
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
