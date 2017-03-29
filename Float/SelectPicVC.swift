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
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var postButton: UIBarButtonItem!
    var postImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"
        navigationController?.hidesBarsOnSwipe = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReusableCellIDs.postImageCell) as? PostPhotoCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {

        } else {
            if let img = postImage {
                cell.postImage.image = img
            }
        }
        return cell
    }
}

extension SelectPicVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}



