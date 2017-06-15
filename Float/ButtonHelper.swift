//
//  ButtonHelper.swift
//  Float
//
//  Created by Matt Deuschle on 6/15/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func stylizeFacebook() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.accentColor().cgColor
        self.setTitle(Constant.ButtonTitle.facebook.rawValue, for: .normal)
    }
}
