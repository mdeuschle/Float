//
//  ProfileVC.swift
//  Float
//
//  Created by Matt Deuschle on 4/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ProfileVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ProfileCell")
        cell.accessoryType = .disclosureIndicator
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
            Alert.init(viewController: self).addAlertWithAction(alertMessage: "Logout", message: "Are you sure you would like to logout?", actionButton: "Logout", handler: { logout in
                print("LOGOUT!")
            })
        default:
            Alert.init(viewController: self).addAlertWithCancel(alertMessage: "AlertTwo", message: "Hey Two")
        }
    }
}



