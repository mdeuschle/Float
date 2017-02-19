//
//  LogOutVC.swift
//  Float
//
//  Created by Matt Deuschle on 2/1/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogOutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        logout()

    }

    func logout() {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: Constant.KeyType.keyUID)
        print("*Removed keychain: \(keychainResult)")
        do {
            try FIRAuth.auth()?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Unable to sign out \(error)")
        }
    }
}
