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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Image"

    }
}


// MARK: - UITableViewDataSource
extension SelectPicVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
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

