//
//  User.swift
//  Float
//
//  Created by Matt Deuschle on 6/22/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

class User: FirebaseModel {
    let uid: String
    let email: String
    var firebaseReference: FIRDatabaseReference?

    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }

    required init?(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: Any],
            let uid = snapshotValue[FirebaseUserKeys.uid.rawValue] as? String,
            let email = snapshotValue[FirebaseUserKeys.email.rawValue] as? String
        {
            self.uid = uid
            self.email = email
            self.firebaseReference = snapshot.ref
        } else {
            return nil
        }
    }

    func toDictionary() -> [String: Any] {
        return [
            FirebaseUserKeys.uid.rawValue: self.uid,
            FirebaseUserKeys.email.rawValue: self.email,
        ]
    }

    func removeFromFirebase() {
        self.firebaseReference?.removeValue()
    }

    func createInFirebase() {
        let reference = FIRDatabase.database().reference(withPath: FirebasePaths.users.rawValue)
        self.firebaseReference = reference.child(self.uid)
        self.firebaseReference?.setValue(self.toDictionary())
    }

    static func pathFor(uid: String) -> String {
        return [FirebasePaths.users.rawValue, uid].joined(separator: FirebasePathSeparator)
    }

    func path() -> String {
        return User.pathFor(uid: self.uid)
    }
}
