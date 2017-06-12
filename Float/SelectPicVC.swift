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
    var profileImage: UIImage?
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
        DataService.shared.getProfileImage { (data) in
            guard let profileImg = UIImage(data: data) else {
                return
            }
            if let profileImageData = UIImageJPEGRepresentation(profileImg, 0.2) {
                let profileImageUID = NSUUID().uuidString
                let profileMetaData = FIRStorageMetadata()
                profileMetaData.contentType = "image/jpeg"
                DataService.shared.refProfileImages.child(profileImageUID).put(profileImageData, metadata: profileMetaData) { meta, err in
                    if err != nil {
                        print("NO PROFILE PIC")
                    } else {
                        print("UPLOAD PROFILE PIC")
                        guard let profileURL = meta?.downloadURL()?.absoluteString else {
                            print("UNABLE TO DOWNLOAD PROFILE URL")
                            return
                        }
                        guard let img = self.postImage else {
                            print("NO IMAGE?")
                            return
                        }
                        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
                            let imageUID = NSUUID().uuidString
                            let metaData = FIRStorageMetadata()
                            metaData.contentType = "image/jpeg"
                            DataService.shared.refPostsImages.child(imageUID).put(imageData, metadata: metaData) { metaData, error in
                                if error != nil {
                                    print("Unable to upload to Firebase")
                                } else {
                                    print("Uploaded to FB Storage")
                                    if let downloadURL = metaData?.downloadURL()?.absoluteString {
                                        self.postToFireBase(imageURL: downloadURL, profileURL: profileURL)
                                    }
                                }
                            }
                        }
                        if let navigation = self.navigationController {
                            navigation.popViewController(animated: true)
                        }
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
    }

    func postToFireBase(imageURL: String, profileURL: String) {
        if let captionText = selectPicTextView.text {
            let postDic: [String: AnyObject] = [
                Constant.PostKeyType.imageURL.rawValue: imageURL as AnyObject,
                Constant.PostKeyType.caption.rawValue: captionText as AnyObject,
                Constant.PostKeyType.upVotes.rawValue: 0 as AnyObject,
                Constant.PostKeyType.downVotes.rawValue: 0 as AnyObject,
                Constant.PostKeyType.userName.rawValue: currentUserName as AnyObject,
                Constant.PostKeyType.timeStamp.rawValue: DateHelper.convertDateToString() as AnyObject,
                Constant.PostKeyType.profileImageURL.rawValue: profileURL as AnyObject,
                Constant.PostKeyType.favorite.rawValue: false as AnyObject
            ]
            DataService.shared.refPosts.childByAutoId().setValue(postDic)
            selectPicTextView.text = ""
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










