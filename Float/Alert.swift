//
//  Alert.swift
//  Float
//
//  Created by Matt Deuschle on 5/26/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

class Alert {

    var viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func addAlertWithCancel(alertMessage: String = "Oh no!", message: String = "Sorry :-(. Not sure what happened....please try again.", cancelHandler: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: alertMessage, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: cancelHandler)
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }

    func addAlertWithAction(alertMessage: String, message: String, actionButton: String, cancelHandler: @escaping ((UIAlertAction) -> Void), handler: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: alertMessage, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        alertController.addAction(cancelAction)
        let handlerAction = UIAlertAction(title: actionButton, style: .destructive, handler: handler)
        alertController.addAction(handlerAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
