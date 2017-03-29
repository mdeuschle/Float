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
    struct KeyType {
        static let keyUID = "uid"
        static let provider = "provider"
    }
    struct ErrorMessage {
        static let password = "6 or more characters"
    }
    struct ReusableCellIDs {
        static let feedCell = "FeedCell"
        static let postImageCell = "PostImageCell"

    }
    struct SegueIDs {
        static let feedSegue = "FeedSegue"
        static let selectPicSegue = "SelectPicSegue"
    }
    struct FontHelper {
        static func americanTypewriter(size: CGFloat) -> UIFont {
            return UIFont(name: "AmericanTypewriter", size: size)!
        }
    }
}

