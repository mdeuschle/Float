//
//  LoginVC.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var appLogoImage: UIImageView!
    @IBOutlet var appTaglineLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        stylizeViews()
        notifications()
    }

    func stylizeViews() {
        facebookButton.layer.borderWidth = 2.0
        facebookButton.layer.borderColor = UIColor.accentColor().cgColor
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("*Textfield Return")
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        appLogoImage.isHidden = false
        appTaglineLabel.isHidden = false
        skipButton.isHidden = false
        view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        appLogoImage.isHidden = true
        appTaglineLabel.isHidden = true
        skipButton.isHidden = true
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                view.frame.origin.y -= keyboardSize.height
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

    func fireBaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let fbUser = user {
                if error != nil {
                    // TODO Popups
                    print("Not able to authenticate with Firebase \(error?.localizedDescription)")
                } else {
                    print("Successfully authenticated with Firebase \(fbUser.debugDescription)")
                }
            }
        })
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "FeedSegue", sender: self)
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let res = result {
                if error != nil {
                    // TODO PopUps
                    print("Not Able To Login To FB \(error?.localizedDescription)")
                } else if result?.isCancelled == true {
                    print("User cancelled FB auth \(res.debugDescription)")
                } else {
                    print("Successfully authenticated with FB \(res)")
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    self.fireBaseAuth(credential)
                    self.performSegue(withIdentifier: "FeedSegue", sender: self)
                }
            }
        }
    }

}
