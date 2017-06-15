//
//  DataService.swift
//  Float
//
//  Created by Matt Deuschle on 2/2/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let dbBase = FIRDatabase.database().reference()
let storageBase = FIRStorage.storage().reference()

class DataService {

    // MARK: - Properties
    static let shared = DataService()
    private var _refBase = dbBase
    private var _refPosts = dbBase.child("posts")
    private var _refUsers = dbBase.child("users")
    private var _refPostsImages = storageBase.child("post-pics")
    private var _refProfileImages = storageBase.child("profile-pics")

    var refBase: FIRDatabaseReference {
        return _refBase
    }

    var refPosts: FIRDatabaseReference {
        return _refPosts
    }

    var refUsers: FIRDatabaseReference {
        return _refUsers
    }

    var refUserCurrent: FIRDatabaseReference {
        guard let uid = KeychainWrapper.standard.string(forKey: Constant.UserKeyType.keyUID.rawValue) else {
            let noUser = refUsers.child("")
            return noUser
        }
        let user = refUsers.child(uid)
        return user
    }

    var refPostsImages: FIRStorageReference {
        return _refPostsImages
    }

    var refProfileImages: FIRStorageReference {
        return _refProfileImages
    }

    // MARK: - Functions
    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        refUsers.child(uid).updateChildValues(userData)
    }

    func displayProfile(profileImageView: UIImageView, nameTextField: UITextField) {
        DataService.shared.refUserCurrent.observe(.value, with: { snapShot in
            let value = snapShot.value as? NSDictionary
            let profileImageURL = value?[Constant.UserKeyType.profileImage.rawValue] as? String ?? ""
            if let url = URL(string: profileImageURL) {
                do {
                    let data = try Data(contentsOf: url)
                    profileImageView.image = UIImage(data: data)
                } catch {
                    print("PROFILE IMAGE ERROR: \(error)")
                }
            }
            nameTextField.text = value?[Constant.UserKeyType.userName.rawValue] as? String ?? ""
        })
    }

    func getImagesFromFirebase(url: String, handler: @escaping (_ data: Data) -> ()) {
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("Error downloading image to FB Storage \(String(describing: error))")
            } else {
                if let imageData = data {
                    handler(imageData)
                }
                print("Image doanloaded from FB Storage")
            }
        })
    }

    //            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
    //            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
    //                if error != nil {
    //                    print("Error downloading image to FB Storage \(String(describing: error))")
    //                } else {
    //                    if let imageData = data {
    //                        if let img = UIImage(data: imageData) {
    //                            self.mainImage.image = img
    //                            MainFeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
    //                        }
    //                    }
    //                    print("Image doanloaded from FB Storage")
    //                }
    //            })


    func getProfileImage(handler: @escaping (_ data: Data) -> ()) {
        DataService.shared.refUserCurrent.observe(.value, with: { snapShot in
            let value = snapShot.value as? NSDictionary
            let profileImageURL = value?[Constant.UserKeyType.profileImage.rawValue] as? String ?? ""
            if let url = URL(string: profileImageURL) {
                do {
                    let data = try Data(contentsOf: url)
                    handler(data)
                } catch {
                    print("PROFILE IMAGE ERROR: \(error)")
                }
            }
        })
    }
    
}

















