//
//  MotionEffect.swift
//  Float
//
//  Created by Matt Deuschle on 4/15/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIMotionEffect {
    class func addMotion(amount: Float) -> UIMotionEffect {
        let verticalMotion = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                         type: .tiltAlongVerticalAxis)
        verticalMotion.minimumRelativeValue = -amount
        verticalMotion.maximumRelativeValue = amount
        let horizontalMotion = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                           type: .tiltAlongHorizontalAxis)
        horizontalMotion.minimumRelativeValue = -amount
        horizontalMotion.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotion, verticalMotion]
        return group
    }
}
