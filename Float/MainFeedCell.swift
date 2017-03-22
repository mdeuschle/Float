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
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var favoritesButton: UIButton!
    @IBOutlet var upVoteButton: UIButton!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var downVoteButton: UIButton!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var commentsCountLabel: UILabel!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!

    let postImage: UIImage = #imageLiteral(resourceName: "imageBench")
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    func configCell(post: Post) {
        self.post = post
        self.mainImage.image = postImage
        self.voteCountLabel.text = "\(post.upVotes)"
    }
}
