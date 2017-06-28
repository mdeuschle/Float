//
//  CurrentUser.swift
//  Float
//
//  Created by Matt Deuschle on 6/22/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class CurrentUser {

    let uid: String

    init?() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return nil
        }
        self.uid = uid
    }

    func addPicture(image: UIImage, firebasePhoto: Photo) {
        if let reference = firebasePhoto.storageReference() {
            if let resizedImage = image.resize(width: 300),
                let data = UIImagePNGRepresentation(resizedImage) {
                reference.put(data, metadata: Photo.metaData())
                if let reference = createFirebaseReference(components: [self.path(), FirebaseUserKeys.photo.rawValue, firebasePhoto.key]) {
                    reference.setValue(true)
                }
            }
        }
    }

    func path() -> String {
        return User.pathFor(uid: self.uid)
    }

    func setOwner(postKey: String) {
        let reference = createFirebaseReference(components: [self.path(), FirebaseUserKeys.posts.rawValue, postKey])
        reference?.setValue(true)
    }
}
