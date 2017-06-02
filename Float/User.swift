//
//  User.swift
//  Float
//
//  Created by Matt Deuschle on 6/1/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _provider: String!
    private var _email: String!
    private var _userName: String!
    private var _profileImage: String!
    private var _uid: String!
    private var _ref: FIRDatabaseReference!
    private var _key = ""

    var provider: String {
        return _provider
    }
    var email: String {
        return _email
    }
    var userName: String {
        return _userName
    }
    var profileImage: String {
        return _profileImage
    }
    var uid: String {
        return _uid
    }
    var ref: FIRDatabaseReference {
        return _ref
    }
    var key: String {
        return _key
    }

    init(provider: String, email: String, userName: String, profileImage: String, uid: String) {
        _provider = provider
        _email = email
        _userName = userName
        _profileImage = profileImage
        _uid = uid
        _ref = FIRDatabase.database().reference()
    }

    func toAnyObject() -> [String: Any] {
        return ["provider": _provider,
        "email": _email,
        "userName": _userName,
        "profileImage": _profileImage,
        "uid": _uid]
    }
}














