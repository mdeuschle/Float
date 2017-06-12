//
//  Constants.swift
//  Float
//
//  Created by Matt Deuschle on 2/2/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

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

