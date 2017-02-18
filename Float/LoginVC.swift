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
        stylizeErrorLabel(text: Constants.ErrorMessages.password)
    }

    func stylizeViews() {
        facebookButton.layer.borderWidth = 2.0
        facebookButton.layer.borderColor = UIColor.accentColor().cgColor
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
    }

    func stylizeErrorLabel(text: String) {
        errorLabel.text = text
        if text == Constants.ErrorMessages.password {
            errorLabel.textColor = .dividerColor()
        } else {
            errorLabel.textColor = .magenta
        }
    }

    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLogin()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        appLogoImage.isHidden = false
        appTaglineLabel.isHidden = false
        skipButton.isHidden = false
        view.endEditing(true)
        stylizeErrorLabel(text: Constants.ErrorMessages.password)
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        appLogoImage.isHidden = true
        appTaglineLabel.isHidden = true
        skipButton.isHidden = true
        facebookButton.setTitle("LOGIN", for: .normal)
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

    func createUserDataDic(providerID: String) -> [String: String] {
        return ["provider": providerID]
    }

    func userSignIn(id: String, userData: [String: String]) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: Constants.KeyTypes.keyUID)
        clearTextFields()
        appLogoImage.isHidden = false
        appTaglineLabel.isHidden = false
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
        performSegue(withIdentifier: "FeedSegue", sender: nil)
    }

    func userLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("User email authenciated with Firebase")
                    if let emailUser = user {
                        let userData = self.createUserDataDic(providerID: emailUser.providerID)
                        self.userSignIn(id: emailUser.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let emailUser = user {
                            if error != nil {
                                if let err = error {
                                    self.stylizeErrorLabel(text: err.localizedDescription)
                                }
                            } else {
                                print("New user created")
                                let userData = self.createUserDataDic(providerID: emailUser.providerID)
                                self.userSignIn(id: emailUser.uid, userData: userData)
                            }
                        } else {
                            if let err = error {
                                self.stylizeErrorLabel(text: err.localizedDescription)
                            }
                        }
                    })
                }
            })
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
        if facebookButton.titleLabel?.text == "SIGN UP VIA FACEBOOK" {
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
        } else {
            userLogin()
        }
    }

}
