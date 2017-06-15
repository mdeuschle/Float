//
//  LabelHelper.swift
//  Float
//
//  Created by Matt Deuschle on 6/15/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func stylizeError(text: String = Constant.ErrorMessage.password.rawValue) {
        self.text = text
        if text == Constant.ErrorMessage.password.rawValue {
            self.textColor = .dividerColor()
        } else {
            self.textColor = .magenta
        }
    }
}

