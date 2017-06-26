//
//  Constants.swift
//  Float
//
//  Created by Matt Deuschle on 2/2/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let FirebasePathSeparator = "/"
let FirebasePhotosPath = "photos"
let FirebaseEmptyValue = "null"

enum FirebasePaths: String {
    case users = "users"
    case posts = "posts"
}

enum FirebaseUserKeys: String {
    case uid = "uid"
    case email = "email"
    case posts = "posts"
    case photo = "photo"
}

enum FirebasePostKeys: String {
    case image = "image"
    case caption = "caption"
    case owner = "owner"
    case upVotes = "upVotes"
    case downVotes = "downVotes"
    case timeStamp = "timeStamp"
    case isFavorite = "isFavorite"
}

enum SegueID: String {
    case feedSegue = "FeedSegue"
    case selectPhotosSegue = "SelectPhotosSegue"
    case editProfilePicSegue = "EditProfilePicSegue"
}

enum ButtonTitle: String {
    case facebook = "SIGN UP VIA FACEBOOK"
    case login = "LOGIN"
    case post = "POST"
}

enum ErrorMessage: String {
    case password = "6 or more characters"
}

enum ViewControllerTitle: String {
    case uploadNewProfile = "Upload New Profile"
    case postImage = "Post Image"
}

func createFirebaseReference(components: [Any]?) -> FIRDatabaseReference? {
    if let path = firebasePath(components: components) {
        return FIRDatabase.database().reference(withPath: path)
    }
    return nil
}

func createFirebaseStorageReference(components: [Any]?) -> FIRStorageReference? {
    if let path = firebasePath(components: components) {
        let storage = FIRStorage.storage()
        let reference = storage.reference(withPath: path)
        return reference
    }
    return nil
}

fileprivate func firebasePath(components: [Any]?) -> String? {
    guard let components = components else {
        return nil
    }

    var strings = [String]()
    for thing in components {
        if let string = thing as? String {
            strings.append(string)
        }

        if let path = thing as? FirebasePaths {
            strings.append(path.rawValue)
        }
    }

    if strings.count > 0 {
        return strings.joined(separator: FirebasePathSeparator)
    }

    return nil
}

/* Converts a dictionary of keys and bools to an array of strings with "true" keys
 */
func stringsArrayWithTrueKeys(snapshotValue: Any?) -> [String]? {
    var result: [String]? = nil

    if let dict = snapshotValue as? [String: Bool] {

        var keys = [String]()
        for (key, value) in dict {
            if value == true {
                keys.append(key)
            }
        }

        if keys.count > 0 {
            result = keys
        } else {
            result = nil
        }
    }
    return result
}








struct Constant {
    enum UserKeyType: String {
        case keyUID = "uid"
        case provider = "provider"
        case email = "email"
        case userName = "userName"
        case profileImage = "profileImage"
    }
    enum PostKeyType: String {
        case imageURL = "imageURL"
        case caption = "caption"
        case upVotes = "upVotes"
        case downVotes = "downVotes"
        case favorite = "favorite"
        case userName = "userName"
        case timeStamp = "timeStamp"
        case profileImageURL = "profileImageURL"
    }
    enum ButtonTitle: String {
        case facebook = "SIGN UP VIA FACEBOOK"
        case login = "LOGIN"
    }
    enum ContentType: String {
        case jpeg = "image/jpeg"
        case png = "image/png"
    }
    enum UserType: String {
        case firebase = "Firebase"
        case facebook = "facebook.com"
    }
    enum ErrorMessage: String {
        case password = "6 or more characters"
    }
    enum ReusableCellIDs: String {
        case feedCell = "FeedCell"
        case postImageCell = "PostImageCell"
        case profileCell = "ProfileCell"
    }
    enum SegueIDs: String {
        case feedSegue = "FeedSegue"
        case selectPhotosSegue = "SelectPhotosSegue"
        case editProfilePicSegue = "EditProfilePicSegue"
    }
    enum Notification: String {
        case tabSelected = "TabSelected"
    }
    enum ViewControllerTitle: String {
        case uploadNewProfile = "Upload New Profile"
        case postImage = "Post Image"
    }
    enum URL: String {
        case defaultProfileImage = "https://firebasestorage.googleapis.com/v0/b/float-3aae5.appspot.com/o/profile-pics%2FplaceHolder.jpg?alt=media&token=7f5a2247-8d48-4fd4-986b-0b56d296133c"
    }

    struct FontHelper {
        static func americanTypewriter(size: CGFloat) -> UIFont {
            return UIFont(name: "AmericanTypewriter", size: size)!
        }
    }
}

