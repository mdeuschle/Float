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
    var upVoteRef: FIRDatabaseReference!
    var downVoteRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        upVoteButton.addTarget(self, action: #selector(MainFeedCell.upVoteTapped), for: .touchUpInside)
        downVoteButton.addTarget(self, action: #selector(MainFeedCell.downVoteTapped), for: .touchUpInside)
    }
    
    func configCell(post: Post, img: UIImage? = nil) {
        self.post = post
        upVoteRef = DataService.shared.refUserCurrent.child("upVotes").child(post.postKey)
        downVoteRef = DataService.shared.refUserCurrent.child("downVotes").child(post.postKey)
        postTitleLabel.text = post.caption
        let totalVotes = post.upVotes - post.downVotes
        voteCountLabel.text = "\(totalVotes)"
        timeStampLabel.text = DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
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
        upVoteRef.observe(.value, with: { (upVote) in
            if let _ = upVote.value as? NSNull {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "whiteUpArrow"), for: .normal)
            } else {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "cyanUpArrow"), for: .normal)
            }
        })
        downVoteRef.observe(.value, with: { (downVote) in
            if let _ = downVote.value as? NSNull {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "whiteDownArrow"), for: .normal)
            } else {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "cyanDownArrow"), for: .normal)
            }
        })
    }

    func upVoteTapped() {
        upVoteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "cyanUpArrow"), for: .normal)
                self.post.adjustUpVotes(isUpVoated: true)
                self.upVoteRef.setValue(true)
            } else {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "whiteUpArrow"), for: .normal)
                self.post.adjustUpVotes(isUpVoated: false)
                self.upVoteRef.removeValue()
            }
        })
    }

    func downVoteTapped() {
        downVoteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "cyanDownArrow"), for: .normal)
                self.post.adjustDownVotes(isDownVoted: true)
                self.downVoteRef.setValue(true)
            } else {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "whiteDownArrow"), for: .normal)
                self.post.adjustDownVotes(isDownVoted: false)
                self.downVoteRef.removeValue()
            }
        })
    }
}















