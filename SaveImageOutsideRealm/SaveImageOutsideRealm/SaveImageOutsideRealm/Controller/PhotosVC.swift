//
//  ViewController.swift
//  SaveImageOutsideRealm
//
//  Created by David E Bratton on 12/17/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift

class PhotosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var photos: Results<Photo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    func loadPhotos() {
        if let fetchedPhotos = RealmHelper.getAllPhotos() {
            photos = fetchedPhotos
        }
        tableView.reloadData()
    }
    
    func deleteImageFromDocumentDir(localPathName: String) {
        let filemanager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(localPathName)
        do {
            try filemanager.removeItem(atPath: destinationPath)
        } catch let error as NSError {
            print("Error Deleting Image from Documents Directory: \(error.localizedDescription)")
        }
    }
}

extension PhotosVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numPhotos = photos {
            return numPhotos.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let index = photos {
            let currentPhoto = index[indexPath.row]
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsPath = paths[0]
            let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(currentPhoto.photoPath).path
            print("RETRIEVE PATH")
            print(filePath as Any)
            cell.imageView!.image = UIImage(contentsOfFile: filePath)
            cell.textLabel?.text = currentPhoto.photoDescription
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let photoToDelete = photos {
                let selectedPhoto = photoToDelete[indexPath.row]
                print("Delete at Path: \(selectedPhoto.photoPath)")
                deleteImageFromDocumentDir(localPathName: "\(selectedPhoto.photoPath)")
                RealmHelper.deletePhoto(photo: selectedPhoto)
                loadPhotos()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPhoto = photos?[indexPath.row] {
            performSegue(withIdentifier: "updatePhoto", sender: selectedPhoto)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updatePhoto" {
            if let destinationVC = segue.destination as? UpdatePhotoVC {
                if let passedPhoto = sender as? Photo {
                    destinationVC.passedPhoto = passedPhoto
                }
            }
        }
    }
}
