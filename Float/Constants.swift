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
    func segueToMainFeed(vc: UIViewController) {
        vc.performSegue(withIdentifier: "FeedSegue", sender: nil)
    }
}

