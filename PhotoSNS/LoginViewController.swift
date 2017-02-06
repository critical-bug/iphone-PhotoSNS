//
//  LoginViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var displayNameTextField: UITextField!

	@IBAction func handleLoginButton(_ sender: Any) {
	}

	@IBAction func handleCreateAccountButton(_ sender: Any) {
		if let address = emailTextField.text,
			let password = passwordTextField.text,
			let displayName = displayNameTextField.text {
			if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
				print("DEBUG_PRINT: please fulfill all fields")
				return
			}
			FIRAuth.auth()?.createUser(withEmail: address, password: password) { user, error in
				if let error = error {
					// エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
					print("DEBUG_PRINT: " + error.localizedDescription)
					return
				}
				let user = FIRAuth.auth()?.currentUser
				if let user = user {
					let changeRequest = user.profileChangeRequest()
					changeRequest.displayName = displayName
					changeRequest.commitChanges { error in
						if let error = error {
							print("DEBUG_PRINT: " + error.localizedDescription)
						}
						print("DEBUG_PRINT: success to set [displayName = \(user.displayName)]")

						// 画面を閉じてViewControllerに戻る
						self.dismiss(animated: true, completion: nil)
					}
				} else {
					print("DEBUG_PRINT: cannot set displayName")
				}
			}
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
