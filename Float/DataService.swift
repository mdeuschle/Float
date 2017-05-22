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

let dbBase = FIRDatabase.database().reference()
let storageBase = FIRStorage.storage().reference()

class DataService {

// MARK: - Properties
    static let shared = DataService()
    private var _refBase = dbBase
    private var _refPosts = dbBase.child("posts")
    private var _refUsers = dbBase.child("users")
    private var _refPostsImages = storageBase.child("post-pics")

    var refBase: FIRDatabaseReference {
        return _refBase
    }

    var refPosts: FIRDatabaseReference {
        return _refPosts
    }

    var refUsers: FIRDatabaseReference {
        return _refUsers
    }

    var refUserCurrent: FIRDatabaseReference {
        guard let uid = KeychainWrapper.standard.string(forKey: Constant.KeyType.keyUID.rawValue) else {
            let noUser = refUsers.child("")
            return noUser
        }
        let user = refUsers.child(uid)
        return user
    }

    var refPostsImages: FIRStorageReference {
        return _refPostsImages
    }

// MARK: - Functions
    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        refUsers.child(uid).updateChildValues(userData)
    }
}
