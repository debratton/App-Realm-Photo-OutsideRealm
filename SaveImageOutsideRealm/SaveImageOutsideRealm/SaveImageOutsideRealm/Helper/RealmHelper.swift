//
//  RealmHelper.swift
//  SaveImageOutsideRealm
//
//  Created by David E Bratton on 12/17/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    static let realm = try! Realm()
    
    static func getAllPhotos() -> Results<Photo>? {
        var photos: Results<Photo>?
        photos = realm.objects(Photo.self)
        let sortedPhotos = photos?.sorted(byKeyPath: "photoDescription", ascending: true)
        return sortedPhotos
    }
    
    static func savePhoto(photo: Photo) {
        do {
            try realm.write {
                realm.add(photo)
            }
        } catch {
            print("Error Saving Photo: \(error.localizedDescription)")
        }
    }
    
    static func updatePhoto(photo: Photo) {
        let id = photo.photoID
        let description = photo.photoDescription
        let photoPath = photo.photoPath
        
        do {
            try realm.write {
                realm.create(Photo.self, value: [
                    "photoID": id,
                    "photoDescription": description,
                    "photoPath": photoPath], update: true)
            }
        } catch {
            print("Error Updating Photo: \(error.localizedDescription)")
        }
    }
    
    static func deletePhoto(photo: Photo) {
        do {
            try realm.write {
                realm.delete(photo)
            }
        } catch {
            print("Error Deleting Photo: \(error.localizedDescription)")
        }
    }
}
