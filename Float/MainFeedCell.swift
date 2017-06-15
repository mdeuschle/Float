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
    var favoriteRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        upVoteButton.addTarget(self, action: #selector(MainFeedCell.upVoteTapped), for: .touchUpInside)
        downVoteButton.addTarget(self, action: #selector(MainFeedCell.downVoteTapped), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(MainFeedCell.favoriteTapped), for: .touchUpInside)
    }

    func configCell(post: Post, img: UIImage? = nil, profileImg: UIImage? = nil) {
        self.post = post
        upVoteRef = DataService.shared.refUserCurrent.child(Constant.PostKeyType.upVotes.rawValue).child(post.postKey)
        downVoteRef = DataService.shared.refUserCurrent.child(Constant.PostKeyType.downVotes.rawValue).child(post.postKey)
        favoriteRef = DataService.shared.refUserCurrent.child(Constant.PostKeyType.favorite.rawValue).child(post.postKey)
        postTitleLabel.text = post.caption
        let totalVotes = post.upVotes - post.downVotes
        voteCountLabel.text = "\(totalVotes)"
        timeStampLabel.text = DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
        if img != nil {
            print("Post image downloaded from cache")
            mainImage.image = img
        } else {
            DataService.shared.getImagesFromFirebase(url: post.imageURL, handler: { (data) in
                if let img = UIImage(data: data) {
                    self.mainImage.image = img
                    MainFeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                }
            })
        }
        if profileImg != nil {
            print("Profile image downloaded from cache")
            profileImage.image = img
        } else {
            DataService.shared.refProfileImages.child("\(DataService.shared.refUserCurrent.key)").downloadURL { (profileURL, err) in
                if let err = err {
                    print("OOPS: \(err.localizedDescription)")
                } else {
                    DataService.shared.getImagesFromFirebase(url: "\(String(describing: profileURL))", handler: { (data) in
                        if let img = UIImage(data: data) {
                            self.profileImage.image = img
                            MainFeedVC.profileImageCache.setObject(img, forKey: "\(String(describing: profileURL))" as NSString)
                        }
                    })
                }
            }
        }
        upVoteRef.observe(.value, with: { upVote in
            if let _ = upVote.value as? NSNull {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "whiteUpArrow"), for: .normal)
            } else {
                self.upVoteButton.setImage(#imageLiteral(resourceName: "cyanUpArrow"), for: .normal)
            }
        })
        downVoteRef.observe(.value, with: { downVote in
            if let _ = downVote.value as? NSNull {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "whiteDownArrow"), for: .normal)
            } else {
                self.downVoteButton.setImage(#imageLiteral(resourceName: "cyanDownArrow"), for: .normal)
            }
        })
        favoriteRef.observe(.value, with: { favorite in
            if let _ = favorite.value as? NSNull {
                self.favoritesButton.setImage(#imageLiteral(resourceName: "greyStar"), for: .normal)
            } else {
                self.favoritesButton.setImage(#imageLiteral(resourceName: "cyanStar"), for: .normal)
            }
        })
    }

    func upVoteTapped() {
        upVoteRef.observeSingleEvent(of: .value, with: { snapshot in
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
        downVoteRef.observeSingleEvent(of: .value, with: { snapshot in
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

    func favoriteTapped() {
        favoriteRef.observeSingleEvent(of: .value, with: { favorite in
            if let _ = favorite.value as? NSNull {
                self.favoritesButton.setImage(#imageLiteral(resourceName: "cyanStar"), for: .normal)
                self.post.adjustFavorites(isFavorite: true)
                self.favoriteRef.setValue(true)
            } else {
                self.favoritesButton.setImage(#imageLiteral(resourceName: "greyStar"), for: .normal)
                self.post.adjustFavorites(isFavorite: false)
                self.favoriteRef.removeValue()
            }
        })
    }
}















