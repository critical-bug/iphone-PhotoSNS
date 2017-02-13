//
//  SettingViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ESTabBarController

class SettingViewController: UIViewController {

	@IBOutlet weak var displayNameTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()

		let user = FIRAuth.auth()?.currentUser
		if let user = user {
			displayNameTextField.text = user.displayName
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func handleChangeButton(_ sender: Any) {
		if let displayName = displayNameTextField.text {
			if displayName.isEmpty {
				SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
				return
			}

			if let user = FIRAuth.auth()?.currentUser {
				let changeRequest = user.profileChangeRequest()
				changeRequest.displayName = displayName
				changeRequest.commitChanges { error in
					if let error = error {
						print("DEBUG_PRINT: " + error.localizedDescription)
					}
					print("DEBUG_PRINT: [displayName = \(user.displayName)]の設定に成功しました。")

					SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
				}
			} else {
				print("DEBUG_PRINT: displayNameの設定に失敗しました。")
			}
		}
		self.view.endEditing(true)
	}

	@IBAction func handleLogoutButton(_ sender: Any) {
		try! FIRAuth.auth()?.signOut()

		let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
		self.present(loginViewController!, animated: true, completion: nil)

		// ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
		let tabBarController = parent as! ESTabBarController
		tabBarController.setSelectedIndex(0, animated: false)
	}

}
