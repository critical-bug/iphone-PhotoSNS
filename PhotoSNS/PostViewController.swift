//
//  PostViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

	var image: UIImage!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var captionTextField: UITextField!

	@IBAction func handlePostButton(_ sender: Any) {
	}
	@IBAction func handleCancelButton(_ sender: Any) {
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
