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

    @IBOutlet var selectPicImageView: UIImageView!
    @IBOutlet var selectPicTextView: UITextView!
    var postImage: UIImage?
    var isImageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(SelectPicVC.postButtonTapped))
        if let img = postImage {
            selectPicImageView.image = img
        }
    }

    func postButtonTapped() {
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
        let post: [String: Any] = [
            "caption": selectPicTextView.text,
            "imageURL": imageURL,
            "upVotes": 0
        ]
        let fireBasePost = DataService.shared.refPosts.childByAutoId()
        fireBasePost.setValue(post)
        selectPicTextView.text = ""
        isImageSelected = true
        postImage = UIImage()
    }
}

// MARK: - UITextViewDelegate
extension SelectPicVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .primaryTextColor()
    }
}









