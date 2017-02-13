//
//  ImageSelectViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func handleLibraryButton(_ sender: Any) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
			let pickerController = UIImagePickerController()
			pickerController.delegate = self
			pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
			self.present(pickerController, animated: true, completion: nil)
		}
	}
	@IBAction func handleCameraButton(_ sender: Any) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
			let pickerController = UIImagePickerController()
			pickerController.delegate = self
			pickerController.sourceType = UIImagePickerControllerSourceType.camera
			self.present(pickerController, animated: true, completion: nil)
		}
	}

	@IBAction func handleCancelButton(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

}
