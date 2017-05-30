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
    enum KeyType: String {
        case keyUID = "uid"
        case provider = "provider"
        case email = "email"
        case userName = "userName"
        case profileImage = "profileImage"
    }
    enum ErrorMessage: String {
        case password = "6 or more characters"
    }
    enum ReusableCellIDs: String {
        case feedCell = "FeedCell"
        case postImageCell = "PostImageCell"
    }
    enum SegueIDs: String {
        case feedSegue = "FeedSegue"
        case selectPhotosSegue = "SelectPhotosSegue"
    }
    enum Notification: String {
        case tabSelected = "TabSelected"
    }

    struct FontHelper {
        static func americanTypewriter(size: CGFloat) -> UIFont {
            return UIFont(name: "AmericanTypewriter", size: size)!
        }
    }
}

