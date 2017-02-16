//
//  PostViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {

	var image: UIImage!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var captionTextField: UITextField!

	@IBAction func handlePostButton(_ sender: Any) {
		let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
		let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)

		let time = NSDate.timeIntervalSinceReferenceDate
		let name = FIRAuth.auth()?.currentUser?.displayName

		let postRef = FIRDatabase.database().reference().child(Const.PostPath)
		let postData = ["caption": captionTextField.text!, "image": imageString, "time": String(time), "name": name!]
		postRef.childByAutoId().setValue(postData)

		SVProgressHUD.showSuccess(withStatus: "投稿しました")

		// 全てのモーダルを閉じる
		UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
	}

	@IBAction func handleCancelButton(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.image = image
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
