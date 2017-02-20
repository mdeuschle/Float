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

    let img = #imageLiteral(resourceName: "imageBench")

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.refPosts.observe(.value, with: { (snapshots) in
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                }
            }
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
}

// MARK: - UITableViewDelegate
extension MainFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

// MARK: - UITableViewDataSource
extension MainFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? MainFeedCell else {
            return UITableViewCell()
        }
        cell.configCell(postImage: img)
        return cell
    }
}








