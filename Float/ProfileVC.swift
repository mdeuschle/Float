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

class ProfileVC: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayProfile()
        touchRecognizers()
    }

    func touchRecognizers() {
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.editProfilePicture))
        profileImageView.addGestureRecognizer(imageRecognizer)
        let nameRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.editName))
        profileNameLabel.addGestureRecognizer(nameRecognizer)
    }

    func editProfilePicture() {
        performSegue(withIdentifier: Constant.SegueIDs.editProfilePicSegue.rawValue, sender: self)
    }

    func editName() {
        print("Name touched")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIDs.editProfilePicSegue.rawValue {
            if let dvc = segue.destination as? ChoosePicVC {
                dvc.choosePicLabelString = "Update My Profile Pic"
            }
        }
    }

    func displayProfile() {
        DataService.shared.refUserCurrent.observe(.value, with: { snapShot in
            let value = snapShot.value as? NSDictionary
            let currentUser = value?[Constant.KeyType.userName.rawValue] as? String ?? ""
            let profileUrlString = value?[Constant.KeyType.profileImage.rawValue] as? String ?? ""
            if let url = URL(string: profileUrlString) {
                do {
                    let data = try Data(contentsOf: url)
                    self.profileImageView.image = UIImage(data: data)
                } catch {
                    self.profileImageView.image = #imageLiteral(resourceName: "defaultProfile")
                    print("Profile Image Error: \(error)")
                }
            } else {
                self.profileImageView.image = #imageLiteral(resourceName: "defaultProfile")
            }
            self.profileNameLabel.text = currentUser
        })
    }
}

extension ProfileVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ProfileCell")
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
                let keychainResult = KeychainWrapper.standard.removeObject(forKey: Constant.KeyType.keyUID.rawValue)
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



