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

class LoginVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var appLogoImage: UIImageView!
    @IBOutlet var appTaglineLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButton.stylizeFacebook()
        notifications()
        errorLabel.stylizeError()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let _ = KeychainWrapper.standard.string(forKey: FirebaseUserKeys.uid.rawValue) {
            performSegue(withIdentifier: SegueID.feedSegue.rawValue, sender: nil)
        }
//        if let _ = KeychainWrapper.standard.string(forKey: Constant.UserKeyType.keyUID.rawValue) {
//            performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
//        }
    }

    func userSignIn(id: String) {
//    func userSignIn(id: String, userData: [String: String]) {
//        DataService.shared.createFirebaseDBUser(uid: id, userData: userData)
//        KeychainWrapper.standard.set(id, forKey: Constant.UserKeyType.keyUID.rawValue)
        KeychainWrapper.standard.set(id, forKey: FirebaseUserKeys.uid.rawValue)
        emailTextField.clearText()
        passwordTextField.clearText()
        appLogoImage.isHidden = false
        appTaglineLabel.isHidden = false
        facebookButton.setTitle(ButtonTitle.facebook.rawValue, for: .normal)
//        facebookButton.setTitle(Constant.ButtonTitle.facebook.rawValue, for: .normal)
        performSegue(withIdentifier: SegueID.feedSegue.rawValue, sender: nil)
//        performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
    }

//    func buildUserDic(provider: String, userType: String, userName: String) -> [String: String] {
//        return [Constant.UserKeyType.provider.rawValue: provider,
//                Constant.UserKeyType.email.rawValue: userType,
//                Constant.UserKeyType.userName.rawValue: userName]
//    }

    func userLogin() {
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            let auth = FIRAuth.auth() {
            auth.signIn(withEmail: email, password: password) { user, error in
                if error == nil {
                    if let currentUser = auth.currentUser {
                        self.userSignIn(id: currentUser.uid)
                        print("User email authenciated with Firebase")
                    } else {
                        self.errorLabel.stylizeError(text: error!.localizedDescription)
                    }
                } else {
                    print("There was an error signing in, so let's create one")
                    auth.createUser(withEmail: email, password: password) { newUser, err in
                        if err != nil {
                            self.errorLabel.stylizeError(text: err!.localizedDescription)
                        } else {
                            if let newAuth = FIRAuth.auth() {
                                if let currUser = newAuth.currentUser {
                                    print("New registered emailUser created: \(currUser.uid)")
                                    let user = User(uid: currUser.uid, email: email)
                                    user.createInFirebase()
                                    self.userSignIn(id: currUser.uid)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            Alert(viewController: self).addAlertWithCancel(cancelHandler: { action in
            })
        }
    }

//    func userLogin() {
//        if let email = emailTextField.text,
//            let password = passwordTextField.text,
//            let auth = FIRAuth.auth() {
//            auth.signIn(withEmail: email, password: password, completion: { user, error in
//                if error == nil {
//                    print("User email authenciated with Firebase")
//                    if let emailUser = user {
//                        let userData = self.buildUserDic(provider: emailUser.providerID, userType: email, userName: email)
//                        self.userSignIn(id: emailUser.uid, userData: userData)
//                    }
//                } else {
//                    auth.createUser(withEmail: email, password: password, completion: { user, error in
//                        if let emailUser = user, let profileURL = URL(string: Constant.URL.defaultProfileImage.rawValue) {
//                            if error != nil {
//                                self.errorLabel.stylizeError(text: error!.localizedDescription)
//                            } else {
//                                print("New user created")
//                                self.uploadProfilePic(profileURL: profileURL, uid: emailUser.uid)
//                                let userData = self.buildUserDic(provider: emailUser.providerID, userType: email, userName: email)
//                                self.userSignIn(id: emailUser.uid, userData: userData)
//                            }
//                        } else {
//                            if let err = error {
//                                self.errorLabel.stylizeError(text: err.localizedDescription)
//                            }
//                        }
//                    })
//                }
//            })
//        }
//    }

    func fireBaseAuth(_ credential: FIRAuthCredential) {
        if let auth = FIRAuth.auth() {
            auth.signIn(with: credential) { user, error in
                if let fbUser = user {
                    if error != nil {
                        self.errorLabel.stylizeError(text: error.debugDescription)
                    } else {
                        print("Successfully authenticated FB user with Firebase \(fbUser.debugDescription)")
                        self.userSignIn(id: fbUser.uid)
                    }
                } else {
                    self.errorLabel.stylizeError(text: error.debugDescription)
                }
            }
        } else {
            Alert(viewController: self).addAlertWithCancel(cancelHandler: { (action) in
            })
        }
    }

//    func fireBaseAuth(_ credential: FIRAuthCredential) {
//        if let auth = FIRAuth.auth() {
//            auth.signIn(with: credential, completion: { user, error in
//                if let fbUser = user {
//                    if error != nil {
//                        // TODO Popups
//                        print("Not able to authenticate with Firebase \(String(describing: error?.localizedDescription))")
//                    } else {
//                        print("Successfully authenticated with Firebase \(fbUser.debugDescription)")
//                        if let profileURL = fbUser.photoURL {
//                            self.uploadProfilePic(profileURL: profileURL, uid: fbUser.uid)
//                            let userData = self.buildUserDic(provider: credential.provider, userType: fbUser.email ?? "", userName: fbUser.displayName ?? "")
//                            self.userSignIn(id: fbUser.uid, userData: userData)
//                        }
//                    }
//                }
//            })
//        } else {
//            print("Firebase user not authenticated")
//        }
//    }
//
//    func uploadProfilePic(profileURL: URL, uid: String) {
//        do {
//            let data = try Data(contentsOf: profileURL)
//            guard let img = UIImage(data: data) else {
//                return
//            }
//            if let imageData = UIImageJPEGRepresentation(img, 0.2) {
//                let metaData = FIRStorageMetadata()
//                metaData.contentType = Constant.ContentType.jpeg.rawValue
//                DataService.shared.refProfileImages.child(uid).put(imageData, metadata: metaData) { metaData, error in
//                    if error != nil {
//                        print("Unable to upload default profile pic to firebase")
//                    } else {
//                        print("uploaded fb profile to firebase")
//                        if let downloadURL = metaData?.downloadURL()?.absoluteString {
//                            DataService.shared.refUserCurrent.childByAutoId().setValue(downloadURL)
//                        }
//                    }
//                }
//            }
//        } catch {
//            print("UPLOAD PIC DATA ERROR \(error)")
//        }
//    }

    func isHidden(_ shouldHide: Bool) {
        appLogoImage.isHidden = shouldHide
        appTaglineLabel.isHidden = shouldHide
        skipButton.isHidden = shouldHide
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHidden(false)
        view.endEditing(true)
        errorLabel.stylizeError(text: ErrorMessage.password.rawValue)
//        errorLabel.stylizeError(text: Constant.ErrorMessage.password.rawValue)
        facebookButton.setTitle(ButtonTitle.facebook.rawValue, for: .normal)
//        facebookButton.setTitle(Constant.ButtonTitle.facebook.rawValue, for: .normal)
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueID.feedSegue.rawValue, sender: nil)
//        performSegue(withIdentifier: Constant.SegueIDs.feedSegue.rawValue, sender: nil)
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        if let fbButtonLabel = facebookButton.titleLabel {
            if fbButtonLabel.text == ButtonTitle.facebook.rawValue {
                let fbLogin = FBSDKLoginManager()
                fbLogin.logIn(withReadPermissions: ["email"], from: self) { result, error in
                    if let res = result {
                        if error != nil {
                            self.errorLabel.stylizeError(text: error.debugDescription)
                        } else if res.isCancelled == true {
                            print("User cancelled FB auth \(res.debugDescription)")
                            self.errorLabel.stylizeError(text: res.debugDescription)
                        } else {
                            print("Successfully authenticated with FB \(res)")
                            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                            self.fireBaseAuth(credential)
                        }
                    } else {
                        Alert(viewController: self).addAlertWithCancel(cancelHandler: { (action) in
                        })
                    }
                }
            } else {
                userLogin()
            }
        } else {
            Alert(viewController: self).addAlertWithCancel(cancelHandler: { (action) in
            })
        }
    }


//        if facebookButton.titleLabel?.text == Constant.ButtonTitle.facebook.rawValue {
//            let fbLogin = FBSDKLoginManager()
//            fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//                if let res = result {
//                    if error != nil {
//                        // TODO PopUps
//                        print("Not Able To Login To FB \(String(describing: error?.localizedDescription))")
//                    } else if result?.isCancelled == true {
//                        print("User cancelled FB auth \(res.debugDescription)")
//                    } else {
//                        print("Successfully authenticated with FB \(res)")
//                        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//                        self.fireBaseAuth(credential)
//                    }
//                }
//            }
//        } else {
//            userLogin()
//        }
//    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userLogin()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isHidden(true)
        facebookButton.setTitle(Constant.ButtonTitle.login.rawValue, for: .normal)
    }
}



