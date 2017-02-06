//
//  ViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit
import ESTabBarController

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTab()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func setupTab() {
		let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])

		tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
		tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)

		// 作成したESTabBarControllerを親のViewController（＝self）に追加する
		addChildViewController(tabBarController)
		view.addSubview(tabBarController.view)
		tabBarController.view.frame = view.bounds
		tabBarController.didMove(toParentViewController: self)

		// タブをタップした時に表示するViewControllerを設定する
		let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
		let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")

		tabBarController.setView(homeViewController, at: 0)
		tabBarController.setView(settingViewController, at: 2)

		// 真ん中のタブはボタンとして扱う
		tabBarController.highlightButton(at: 1)
		tabBarController.setAction({
			// ボタンが押されたらImageSelectViewControllerをモーダルで表示する
			let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
			self.present(imageViewController!, animated: true, completion: nil)
		}, at: 1)
	}

}

