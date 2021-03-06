//
//  ProfileVC.swift
//  Float
//
//  Created by Matt Deuschle on 4/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var nameTextField: UITextField!

    var profileImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.shared.displayProfile(profileImageView: profileImageView, nameTextField: nameTextField)
        touchRecognizers()
        navigationItem.rightBarButtonItem = editButtonItem
        enableUserInteration(isEditing: false)
        nameTextField.delegate = self
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            enableUserInteration(isEditing: true)
        } else {
            enableUserInteration(isEditing: false)
            updateName()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enableUserInteration(isEditing: false)
        updateName()
        setEditing(false, animated: true)
        return true
    }

    func enableUserInteration(isEditing: Bool) {
        profileImageView.isUserInteractionEnabled = isEditing
        nameTextField.isUserInteractionEnabled = isEditing
    }

    func updateProfilePic(selectedImage: UIImage) {
        profileImageView.image = selectedImage
    }

    func touchRecognizers() {
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.editProfilePicture))
        profileImageView.addGestureRecognizer(imageRecognizer)
    }

    func editProfilePicture() {
        performSegue(withIdentifier: Constant.SegueIDs.editProfilePicSegue.rawValue, sender: self)
    }

    func updateName() {
        if let name = nameTextField.text {
            DataService.shared.refUserCurrent.updateChildValues([Constant.UserKeyType.userName.rawValue: name], withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("ERROR: \(error.debugDescription)")
                } else {
                    print("REF: \(ref)")
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIDs.editProfilePicSegue.rawValue {
            if let dvc = segue.destination as? ChoosePicVC {
                dvc.choosePicLabelString = Constant.ViewControllerTitle.uploadNewProfile.rawValue
            }
        }
    }
}

extension ProfileVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constant.ReusableCellIDs.profileCell.rawValue)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Logout"
        default:
            cell.textLabel?.text = "Hey"
        }
        return cell
    }
}

extension ProfileVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Alert.init(viewController: self).addAlertWithAction(alertMessage: "Logout", message: "Are you sure you would like to logout?", actionButton: "Logout", cancelHandler: { reload in
                tableView.reloadData()
            }, handler: { logout in
                let keychainResult = KeychainWrapper.standard.removeObject(forKey: Constant.UserKeyType.keyUID.rawValue)
                tableView.reloadData()
                print("*Removed keychain: \(keychainResult)")
                do {
                    try FIRAuth.auth()?.signOut()
                    print("Successfully signed out")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(viewController, animated: true, completion: nil)
                } catch {
                    print("Unable to sign out \(error)")
                }
            })
        default:
            Alert.init(viewController: self).addAlertWithCancel(alertMessage: "AlertTwo", message: "Hey Two", cancelHandler: { reload in
                tableView.reloadData()
            })
        }
    }
}



