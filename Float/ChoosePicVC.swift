//
//  ChoosePicVC.swift
//  Float
//
//  Created by Matt Deuschle on 4/16/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ChoosePicVC: UIViewController, UINavigationControllerDelegate
{

    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var choosePhotoButton: UIButton!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePicker()
    }

    func setUpImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIDs.selectPhotosSegue {
            if let dvc = segue.destination as? SelectPicVC {
                dvc.postImage = selectedImage
            }
        }
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {

    }

    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ChoosePicVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
        } else {
            print("Image not found")
        }
        imagePicker.dismiss(animated: false) {
            self.performSegue(withIdentifier: Constant.SegueIDs.selectPhotosSegue, sender: self)
        }
    }
}
