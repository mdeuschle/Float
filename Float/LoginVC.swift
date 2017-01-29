//
//  LoginVC.swift
//  Float
//
//  Created by Matt Deuschle on 1/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        stylizeViews()
    }

    func stylizeViews() {
        facebookButton.layer.borderWidth = 2.0
        facebookButton.layer.borderColor = UIColor.accentColor().cgColor
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
    }

}
