//
//  SelectPicVC.swift
//  Float
//
//  Created by Matt Deuschle on 3/26/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class SelectPicVC: UIViewController {

    @IBOutlet var selectPicTableview: UITableView!
    var postImage: UIImage?
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var postButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"
        cancelButton.setTitleTextAttributes([NSFontAttributeName: Constant.FontHelper.americanTypewriter(size: 15)], for: .normal)
        postButton.setTitleTextAttributes([NSFontAttributeName: Constant.FontHelper.americanTypewriter(size: 15)], for: .normal)

    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    @IBAction func postButtonTapped(_ sender: Any) {
    }

}

// MARK: - UITableViewDelegate
extension SelectPicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 300
    }
}

// MARK: - UITableViewDataSource
extension SelectPicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postTextCell) as? PictureTitleCell else {
                return PictureTitleCell()
            }
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postImageCell) as? PictureImageCell else {
                return PictureImageCell()
            }
            if let img = postImage {
                print("IMAGE: \(img)")
                cell.postImageImageView.image = img
            }
            return cell
        }
    }
}

