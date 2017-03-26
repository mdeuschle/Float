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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Merica"
        appendPosts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
    }

    func appendPosts() {
        DataService.ds.refPosts.observe(.value, with: { (snapshots) in
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDic = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDic)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTableView.reloadData()
        })
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
    }
    @IBAction func upVoteTapped(_ sender: Any) {
    }
    @IBAction func downVoteTapped(_ sender: Any) {
    }
    @IBAction func commentsButtonTapped(_ sender: Any) {
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    @IBAction func logOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: Constant.KeyType.keyUID)
        print("*Removed keychain: \(keychainResult)")
        do {
            try FIRAuth.auth()?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Unable to sign out \(error)")
        }
    }
    @IBAction func pictureTapped(_ sender: Any) {
    }



}

// MARK: - UITableViewDelegate
extension MainFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

// MARK: - UITableViewDataSource
extension MainFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? MainFeedCell else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configCell(post: post)
        return cell
    }
}








