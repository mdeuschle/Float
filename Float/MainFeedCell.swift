//
//  MainFeedCell.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class MainFeedCell: UITableViewCell {

    @IBOutlet var mainImage: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configCell(postImage: UIImage) {
        self.mainImage.image = postImage
    }


}
