//
//  Photo.swift
//  Float
//
//  Created by Matt Deuschle on 6/24/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

struct Photo {
    let key: String

    static func metaData() -> FIRStorageMetadata {
        let metataData = FIRStorageMetadata()
        metataData.contentType = Constant.ContentType.png.rawValue
        return metataData
    }

    static func storageReference() -> FIRStorageReference? {
        let imageUID = UUID().uuidString
        return createFirebaseStorageReference(components: [FirebasePhotosPath, imageUID])
    }

    func storageReference() -> FIRStorageReference? {
        return createFirebaseStorageReference(components: [FirebasePhotosPath, key])
    }
}
