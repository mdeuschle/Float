//
//  MainFeedCell.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

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

    //    let postImage: UIImage = #imageLiteral(resourceName: "imageBench")
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    func configCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.voteCountLabel.text = "\(post.upVotes)"

        if img != nil {
            self.mainImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Error downloading image to FB Storage \(error)")
                } else {
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.mainImage.image = img
                            MainFeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                    print("Image doanloaded from FB Storage")
                }
            })
        }
    }
}















