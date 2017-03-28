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
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    static var imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Merica"
        appendPosts()
        setUpImagePicker()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = true
    }

    func setUpImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIDs.selectPicSegue {
            if let dvc = segue.destination as? SelectPicVC {
                dvc.postImage = selectedImage
            }
        }
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
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension MainFeedVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.feedCell) as? MainFeedCell else {
            return MainFeedCell()
        }
        let post = posts[indexPath.row]
        if let img = MainFeedVC.imageCache.object(forKey: post.imageURL as NSString) {
            cell.configCell(post: post, img: img)
            return cell
        } else {
            cell.configCell(post: post)
            return cell
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainFeedVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
        } else {
            print("Image not found")
        }
        imagePicker.dismiss(animated: false) {
            self.performSegue(withIdentifier: Constant.SegueIDs.selectPicSegue, sender: self)
        }
    }
}

// MARK = UINavigationControllerDelegate
extension MainFeedVC: UINavigationControllerDelegate {

}








