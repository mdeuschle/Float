//
//  MainFeedVC.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MainFeedVC: UIViewController {

    @IBOutlet var feedTableView: UITableView!
    
    var posts: [Post] = []
    static var imageCache = NSCache<NSString, UIImage>()
    static var profileImageCache = NSCache<NSString, UIImage>()
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        observeTabSelected()
        appendPosts()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }

    func observeTabSelected() {
        let notification = NSNotification.Name(rawValue: Constant.Notification.tabSelected.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(MainFeedVC.tabSelected), name: notification, object: nil)
    }

    func tabSelected() {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.isNavigationBarHidden = false
    }

    func appendPosts() {
        DataService.shared.refPosts.observe(.value, with: { (snapshots) in
            self.posts = []
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
//                    if let postDic = snap.value as? [String: AnyObject] {
//                        let key = snap.key
//                        let post = Post(postKey: key, postData: postDic)
//                        self.posts.append(post)
//                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }

    @IBAction func logOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: Constant.UserKeyType.keyUID.rawValue)
        print("*Removed keychain: \(keychainResult)")
        do {
            try FIRAuth.auth()?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Unable to sign out \(error)")
        }
    }
}

// MARK: - UITableViewDataSource
extension MainFeedVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.feedCell.rawValue) as? MainFeedCell else {
            return MainFeedCell()
        }
//        let post = posts[indexPath.row]
//        if let img = MainFeedVC.imageCache.object(forKey: post.imageURL as NSString), let profileImg = MainFeedVC.profileImageCache.object(forKey: post.profileImageURL as NSString) {
//            print("PROFILE IMAGE: \(profileImg)")
//            cell.configCell(post: post, img: img, profileImg: profileImg)
//        } else {
//            cell.configCell(post: post)
//        }
        return cell
    }
}









