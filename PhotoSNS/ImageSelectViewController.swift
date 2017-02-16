//
//  ImageSelectViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {

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

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if info[UIImagePickerControllerOriginalImage] != nil {
			// 撮影/選択された画像を取得する
			let image = info[UIImagePickerControllerOriginalImage] as! UIImage

			// あとでAdobeUXImageEditorを起動する
			// AdobeUXImageEditorで、受け取ったimageを加工できる
			// ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
			DispatchQueue.main.async {
				// AdobeImageEditorを起動する
				let adobeViewController = AdobeUXImageEditorViewController(image: image)
				adobeViewController.delegate = self
				self.present(adobeViewController, animated: true, completion:  nil)
			}
		}

		// 閉じる
		picker.dismiss(animated: true, completion: nil)
	}

	func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
		editor.dismiss(animated: true, completion: nil)

		// 投稿の画面を開く
		let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
		postViewController.image = image
		present(postViewController, animated: true, completion: nil)
	}

	func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
		editor.dismiss(animated: true, completion: nil)
	}
}
