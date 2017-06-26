//
//  ImageHelper.swift
//  Float
//
//  Created by Matt Deuschle on 6/22/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(width: CGFloat) -> UIImage? {
        let image = self
        let height = CGFloat(ceil(width/image.size.width * image.size.height))
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        image.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
