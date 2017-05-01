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

    var post: Post!
    var likesRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        upVoteButton.addTarget(self, action: #selector(MainFeedCell.upVoteTapped), for: .touchUpInside)
    }
    func configCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.shared.refUserCurrent.child("upVotes").child(post.postKey)
        postTitleLabel.text = post.caption
        self.voteCountLabel.text = "\(post.upVotes)"



        if img != nil {
            self.mainImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Error downloading image to FB Storage \(String(describing: error))")
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
        likesRef.observe(.value, with: { (upVote) in
            if let _ = upVote.value as? NSNull {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "whiteUpArrow"), for: .normal)
            } else {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "cyanUpArrow"), for: .normal)
            }
        })
    }
    func upVoteTapped() {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "cyanUpArrow"), for: .normal)
                self.post.adjustUpVotes(isUpvoated: true)
                self.likesRef.setValue(true)
            } else {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "whiteUpArrow"), for: .normal)
                self.post.adjustUpVotes(isUpvoated: false)
                self.likesRef.removeValue()
            }
        })
    }
}















