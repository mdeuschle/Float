//
//  TabBarController.swift
//  Float
//
//  Created by Matt Deuschle on 5/22/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let notification = NSNotification.Name(Constant.Notification.tabSelected.rawValue)
        NotificationCenter.default.post(name: notification, object: self)
    }
}
