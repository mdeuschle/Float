//
//  Post.swift
//  Float
//
//  Created by Matt Deuschle on 2/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

class Post {

// MARK: - Vars
    private var _caption: String!
    private var _imageURL: String!
    private var _upVotes: Int!
    private var _downVotes: Int!
    private var _postKey: String!
    private var _userName: String!
    private var _postRef: FIRDatabaseReference!

    var caption: String {
        return _caption
    }
    var imageURL: String {
        return _imageURL
    }
    var upVotes: Int {
        return _upVotes
    }
    var downVotes: Int {
        return _downVotes
    }
    var postKey: String {
        return _postKey
    }
    var userName: String {
        return _userName
    }

// MARK: - Inits
    init(postKey: String, postData: [String: AnyObject]) {
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        if let upVotes = postData["upVotes"] as? Int {
            self._upVotes = upVotes
        }
        if let downVotes = postData["downVotes"] as? Int {
            self._downVotes = downVotes
        }
        if let userName = postData["userName"] as? String {
            self._userName = userName
        } else {
            self._userName = ""
        }
        _postRef = DataService.shared.refPosts.child(_postKey)
    }

// MARK: - Funcs
    func adjustUpVotes(isUpVoated: Bool) {
        if isUpVoated {
            _upVotes = _upVotes + 1
        } else {
            _upVotes = upVotes - 1
        }
        _postRef.child("upVotes").setValue(_upVotes)
    }

    func adjustDownVotes(isDownVoted: Bool) {
        if isDownVoted {
            _downVotes = _downVotes + 1
        } else {
            _downVotes = downVotes - 1
        }
        _postRef.child("downVotes").setValue(_downVotes)
    }
}








