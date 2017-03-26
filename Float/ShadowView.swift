//
//  ShadowView.swift
//  Float
//
//  Created by Matt Deuschle on 3/25/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func awakeFromNib() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}


