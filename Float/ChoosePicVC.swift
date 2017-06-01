//
//  ChoosePicVC.swift
//  Float
//
//  Created by Matt Deuschle on 4/16/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ChoosePicVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var choosePicLabel: UILabel!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var choosePhotoButton: UIButton!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    var choosePicLabelString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        stylizeNavController()
        setUpImagePicker()
        if let picTitle = choosePicLabelString {
            choosePicLabel.text = picTitle
        }
    }

    func stylizeNavController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    func setUpImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIDs.selectPhotosSegue.rawValue {
            if let dvc = segue.destination as? SelectPicVC {
                dvc.postImage = selectedImage
            }
        }
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
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
            self.performSegue(withIdentifier: Constant.SegueIDs.selectPhotosSegue.rawValue, sender: self)
        }
    }
}
