//
//  Photo.swift
//  SaveImageOutsideRealm
//
//  Created by David E Bratton on 12/17/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    @objc dynamic var photoID = UUID().uuidString
    @objc dynamic var photoDescription = ""
    @objc dynamic var photoPath = ""
    
    override static func primaryKey() -> String? {
        return "photoID"
    }
}
