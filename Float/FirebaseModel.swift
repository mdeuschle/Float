//
//  FirebaseModel.swift
//  Float
//
//  Created by Matt Deuschle on 6/22/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseModel {
    init?(snapshot: FIRDataSnapshot)
    func toDictionary() -> [String: Any]
    func removeFromFirebase()
    func createInFirebase()
}
