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
    var currentUserName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"
        notifications()        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(SelectPicVC.postButtonTapped))
        if let img = postImage {
            selectPicImageView.image = img
        }
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SelectPicVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectPicVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                view.frame.origin.y -= keyboardSize.height - 144
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0{
                view.frame.origin.y += keyboardSize.height
            }
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
        tabBarController?.selectedIndex = 0
    }

    func postToFireBase(imageURL: String) {
        if let captionText = selectPicTextView.text {
            let postDic: [String: AnyObject] = [
                "imageURL": imageURL as AnyObject,
                "caption": captionText as AnyObject,
                "upVotes": 0 as AnyObject,
                "downVotes": 0 as AnyObject,
                "currentUser": currentUserName as AnyObject,
                "timeStamp": [".sv": "timestamp"] as AnyObject
            ]
            DataService.shared.refPosts.childByAutoId().setValue(postDic)
            selectPicTextView.text = ""
            isImageSelected = false
        }
    }
}

// MARK: - UITextViewDelegate
extension SelectPicVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .primaryTextColor()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            postButtonTapped()
            view.endEditing(true)
            return false
        } else {
            return true
        }
    }
}










