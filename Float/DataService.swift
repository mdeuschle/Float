//
//  DataService.swift
//  Float
//
//  Created by Matt Deuschle on 2/2/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {

    static let ds = DataService()

    // DB Refs
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")

    // Storage Refs
    private var _REF_POSTS_IMAGES = STORAGE_BASE.child("postPics")

    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }

    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }

    var REF_USER_CURRENT: FIRDatabaseReference {
        guard let uid = KeychainWrapper.standard.string(forKey: Constants.KeyTypes.keyUID) else {
            let noUser = REF_USERS.child("")
            return noUser
        }
        let user = REF_USERS.child(uid)
        return user
    }

    var REF_POSTS_IMAGES: FIRStorageReference {
        return _REF_POSTS_IMAGES
    }

    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
