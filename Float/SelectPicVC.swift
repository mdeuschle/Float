//
//  SelectPicVC.swift
//  Float
//
//  Created by Matt Deuschle on 3/26/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class SelectPicVC: UIViewController {

    @IBOutlet var selectPicTableview: UITableView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var postButton: UIBarButtonItem!
    var postImage: UIImage?
    var isImageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"
        navigationController?.hidesBarsOnSwipe = false
        cancelButton.setTitleTextAttributes([NSFontAttributeName: Constant.FontHelper.americanTypewriter(size: 15)], for: .normal)
        postButton.setTitleTextAttributes([NSFontAttributeName: Constant.FontHelper.americanTypewriter(size: 15)], for: .normal)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let cell = selectPicTableview.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postImageCell) as? PostPhotoCell else {
            return
        }
        guard let post = cell.postTitleTextView.text, post != "" else {
            return
        }
        guard let img = postImage else {
            print("NO IMAGE?")
            return
        }

        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imageUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"

            DataService.shared.refPostsImages.child(imageUID).put(imageData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("Unable to upload to Firebase")
                } else {
                    print("Uploaded to FB Storage")
                    if let downloadURL = metaData?.downloadURL()?.absoluteString {
                        self.postToFireBase(imageURL: downloadURL)
                    }
                }
            }
        }
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }

    func postToFireBase(imageURL: String) {
        guard let cell = selectPicTableview.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postImageCell) as? PostPhotoCell else {
            return
        }
        let post: [String: Any] = [
            "caption": cell.postTitleTextView.text,
            "imageURL": imageURL,
            "upVotes": 0
        ]
        let fireBasePost = DataService.shared.refPosts.childByAutoId()
        fireBasePost.setValue(post)
        cell.postTitleTextView.text = ""
        isImageSelected = true
        postImage = UIImage()
        selectPicTableview.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension SelectPicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}

// MARK: - UITableViewDataSource
extension SelectPicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postImageCell) as? PostPhotoCell else {
            return UITableViewCell()
        }
        if let img = postImage {
            cell.postImage.image = img
        }
        return cell
    }
}

// MARK: - UITextViewDelegate
extension SelectPicVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .primaryTextColor()
    }
}










