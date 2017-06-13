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
        stylizeErrorLabel(text: Constant.ErrorMessage.password.rawValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let _ = KeychainWrapper.standard.string(forKey: Constant.UserKeyType.keyUID.rawValue) {
            performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
        }
    }

    func stylizeViews() {
        facebookButton.layer.borderWidth = 2.0
        facebookButton.layer.borderColor = UIColor.accentColor().cgColor
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
    }

    func hideImages(isHidden: Bool, appLogo: UIImageView, appLabel: UILabel, skipButton: UIButton) {
        appLogo.isHidden = isHidden
        appLabel.isHidden = isHidden
        skipButton.isHidden = isHidden
    }

    func stylizeErrorLabel(text: String) {
        errorLabel.text = text
        if text == Constant.ErrorMessage.password.rawValue {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLogin()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideImages(isHidden: false, appLogo: appLogoImage, appLabel: appTaglineLabel, skipButton: skipButton)
        view.endEditing(true)
        stylizeErrorLabel(text: Constant.ErrorMessage.password.rawValue)
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideImages(isHidden: true, appLogo: appLogoImage, appLabel: appTaglineLabel, skipButton: skipButton)
        facebookButton.setTitle("LOGIN", for: .normal)
    }

    func userSignIn(id: String, userData: [String: String]) {
        DataService.shared.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: Constant.UserKeyType.keyUID.rawValue)
        clearTextFields()
        appLogoImage.isHidden = false
        appTaglineLabel.isHidden = false
        facebookButton.setTitle("SIGN UP VIA FACEBOOK", for: .normal)
        performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
    }

    func createUser(id: String, userType: String, userName: String, profileImage: String) -> [String: String] {
        return [Constant.UserKeyType.provider.rawValue: id,
                Constant.UserKeyType.email.rawValue: userType,
                Constant.UserKeyType.userName.rawValue: userName,
                Constant.UserKeyType.profileImage.rawValue: profileImage]
    }

    func userLogin() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("User email authenciated with Firebase")
                    if let emailUser = user {
                        let userData = self.createUser(id: emailUser.providerID, userType: email, userName: email, profileImage: Constant.URL.defaultProfileImage.rawValue)
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
                                let userData = self.createUser(id: emailUser.providerID, userType: email, userName: email, profileImage: Constant.URL.defaultProfileImage.rawValue)
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
                    print("Not able to authenticate with Firebase \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully authenticated with Firebase \(fbUser.debugDescription)")
                    if let profileURL = fbUser.photoURL {
                        self.addProfilePic(profileURL: profileURL, uid: fbUser.uid)
                        let userData = self.createUser(id: credential.provider, userType: fbUser.email ?? "", userName: fbUser.displayName ?? "", profileImage: String(describing: profileURL))
                        self.userSignIn(id: fbUser.uid, userData: userData)
                    }
                }
            }
        })
    }

    func addProfilePic(profileURL: URL, uid: String) {
        do {
            let data = try Data(contentsOf: profileURL)
            guard let img = UIImage(data: data) else {
                return
            }
            if let imageData = UIImageJPEGRepresentation(img, 0.2) {
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                DataService.shared.refProfileImages.child(uid).put(imageData, metadata: metaData) { metaData, error in
                    if error != nil {
                        print("UNABLE TO DOWNLOAD FB Profile Pic")
                    } else {
                        print("UPLoaded FB Profile Pic to FireBase Storage")
                        if let downloadURL = metaData?.downloadURL()?.absoluteString {
                            DataService.shared.refUserCurrent.childByAutoId().setValue(downloadURL)
                        }
                    }
                }
            }
        } catch {
            print("DATA ERROR \(error)")
        }
    }


    @IBAction func skipButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        if facebookButton.titleLabel?.text == "SIGN UP VIA FACEBOOK" {
            let fbLogin = FBSDKLoginManager()
            fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                if let res = result {
                    if error != nil {
                        // TODO PopUps
                        print("Not Able To Login To FB \(String(describing: error?.localizedDescription))")
                    } else if result?.isCancelled == true {
                        print("User cancelled FB auth \(res.debugDescription)")
                    } else {
                        print("Successfully authenticated with FB \(res)")
                        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                        self.fireBaseAuth(credential)
                    }
                }
            }
        } else {
            userLogin()
        }
    }
}
