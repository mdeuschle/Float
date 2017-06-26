//
//  Post.swift
//  Float
//
//  Created by Matt Deuschle on 2/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

class Post: FirebaseModel {
    let postKey: String?
    let owner: String
    var imageURL: String?
    var caption: String
    var upVotes: Int
    var downVotes: Int
    var isFavorite = false
    var timeStamp: String
    var firebaseReference: FIRDatabaseReference?

    init(owner: String, caption: String, postKey: String?, upVotes: Int, downVotes: Int, isFavorite: Bool, timeStamp: String) {
        self.owner = owner
        self.imageURL = nil
        self.caption = caption
        self.postKey = postKey
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.isFavorite = isFavorite
        self.timeStamp = timeStamp
    }

    required init?(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: Any],
            let owner = snapshotValue[FirebasePostKeys.owner.rawValue] as? String,
            let caption = snapshotValue[FirebasePostKeys.caption.rawValue] as? String,
            let imageURL = snapshotValue[FirebasePostKeys.image.rawValue] as? String,
            let upVotes = snapshotValue[FirebasePostKeys.upVotes.rawValue] as? Int,
            let downVotes = snapshotValue[FirebasePostKeys.downVotes.rawValue] as? Int,
            let isFavorite = snapshotValue[FirebasePostKeys.isFavorite.rawValue] as? Bool,
            let timeStamp = snapshotValue[FirebasePostKeys.timeStamp.rawValue] as? String
        {
            self.owner = owner
            self.caption = caption
            self.imageURL = imageURL
            self.postKey = snapshot.key
            self.upVotes = upVotes
            self.downVotes = downVotes
            self.isFavorite = isFavorite
            self.timeStamp = timeStamp

            self.firebaseReference = snapshot.ref
        } else {
            return nil
        }
    }

    func toDictionary() -> [String: Any] {
        return [
            FirebasePostKeys.owner.rawValue: self.owner,
            FirebasePostKeys.caption.rawValue: self.caption
        ]
    }

    func removeFromFirebase() {
        self.firebaseReference?.removeValue()
    }

    func createInFirebase() {
        let reference = FIRDatabase.database().reference(withPath: FirebasePaths.posts.rawValue)
        if let key = self.postKey {
            self.firebaseReference = reference.child(key)
        } else {
            self.firebaseReference = reference.childByAutoId()
        }
        self.firebaseReference?.setValue(self.toDictionary())
    }

    func addPicture(key: String) {
        guard let postKey = self.postKey else {
            return
        }
        Post.addPicture(imageKey: key, postKey: postKey)
    }

    static func addPicture(imageKey: String, postKey: String) {
        if let reference = createFirebaseReference(components: [Post.pathFor(key: postKey), FirebasePostKeys.image.rawValue, imageKey]) {
            reference.setValue(true)
        }
    }

    static func pathFor(key: String) -> String {
        return [FirebasePaths.posts.rawValue, key].joined(separator: FirebasePathSeparator)
    }
}

//class Post {
//
//    private var _caption: String!
//    private var _imageURL: String!
//    private var _upVotes: Int!
//    private var _downVotes: Int!
//    private var _isFavorite = false
//    private var _postKey: String!
//    private var _userName: String!
//    private var _timeStamp: String!
//    private var _postRef: FIRDatabaseReference!
//    private var _profileImageURL: String!
//
//    var caption: String {
//        return _caption
//    }
//    var imageURL: String {
//        return _imageURL
//    }
//    var upVotes: Int {
//        return _upVotes
//    }
//    var downVotes: Int {
//        return _downVotes
//    }
//    var isFavorite: Bool {
//        return _isFavorite
//    }
//    var postKey: String {
//        return _postKey
//    }
//    var userName: String {
//        return _userName
//    }
//    var timeStamp: String {
//        return _timeStamp
//    }
//    var profileImageURL: String {
//        return _profileImageURL
//    }
//
//    init(postKey: String, postData: [String: AnyObject]) {
//        self._postKey = postKey
//        if let caption = postData[Constant.PostKeyType.caption.rawValue] as? String {
//            self._caption = caption
//        }
//        if let imageURL = postData[Constant.PostKeyType.imageURL.rawValue] as? String {
//            self._imageURL = imageURL
//        }
//        if let upVotes = postData[Constant.PostKeyType.upVotes.rawValue] as? Int {
//            self._upVotes = upVotes
//        }
//        if let downVotes = postData[Constant.PostKeyType.downVotes.rawValue] as? Int {
//            self._downVotes = downVotes
//        }
//        if let isFavorite = postData[Constant.PostKeyType.favorite.rawValue] as? Bool {
//            self._isFavorite = isFavorite
//        }
//        if let userName = postData[Constant.PostKeyType.userName.rawValue] as? String {
//            self._userName = userName
//        } else {
//            self._userName = ""
//        }
//        if let timeStamp = postData[Constant.PostKeyType.timeStamp.rawValue] as? String {
//            self._timeStamp = timeStamp
//        }
//        if let profileImageURL = postData[Constant.PostKeyType.profileImageURL.rawValue] as? String {
//            self._profileImageURL = profileImageURL
//        }
//        _postRef = DataService.shared.refPosts.child(_postKey)
//    }
//
//    func adjustUpVotes(isUpVoated: Bool) {
//        if isUpVoated {
//            _upVotes = _upVotes + 1
//        } else {
//            _upVotes = upVotes - 1
//        }
//        _postRef.child(Constant.PostKeyType.upVotes.rawValue).setValue(_upVotes)
//    }
//
//    func adjustDownVotes(isDownVoted: Bool) {
//        if isDownVoted {
//            _downVotes = _downVotes + 1
//        } else {
//            _downVotes = downVotes - 1
//        }
//        _postRef.child(Constant.PostKeyType.downVotes.rawValue).setValue(_downVotes)
//    }
//    
//    func adjustFavorites(isFavorite: Bool) {
//        if isFavorite {
//            _isFavorite = true
//        } else {
//            _isFavorite = false
//        }
//    }
//}




