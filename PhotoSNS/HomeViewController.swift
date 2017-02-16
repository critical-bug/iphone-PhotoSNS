//
//  HomeViewController.swift
//  PhotoSNS
//
//  Created by 	 on 02/06月.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	var postArray: [PostData] = []
	// FIRDatabaseのobserveEventの登録状態を表す
	var observing = false

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		tableView.allowsSelection = false

		let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "Cell")
		tableView.rowHeight = UITableViewAutomaticDimension
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("DEBUG_PRINT: viewWillAppear")

		if FIRAuth.auth()?.currentUser != nil {
			if self.observing == false {

				// 要素が追加されたらpostArrayに追加してTableViewを再表示する
				let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
				postsRef.observe(.childAdded, with: { snapshot in
					print("DEBUG_PRINT: .childAddedイベントが発生しました。")

					// PostDataクラスを生成して受け取ったデータを設定する
					if let uid = FIRAuth.auth()?.currentUser?.uid {
						let postData = PostData(snapshot: snapshot, myId: uid)
						self.postArray.insert(postData, at: 0)

						// TableViewを再表示する
						self.tableView.reloadData()
					}
				})
				// 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
				postsRef.observe(.childChanged, with: { snapshot in
					print("DEBUG_PRINT: .childChangedイベントが発生しました。")

					if let uid = FIRAuth.auth()?.currentUser?.uid {
						// PostDataクラスを生成して受け取ったデータを設定する
						let postData = PostData(snapshot: snapshot, myId: uid)

						// 保持している配列からidが同じものを探す
						var index: Int = 0
						for post in self.postArray {
							if post.id == postData.id {
								index = self.postArray.index(of: post)!
								break
							}
						}

						// 差し替えるため一度削除する
						self.postArray.remove(at: index)

						// 削除したところに更新済みのでデータを追加する
						self.postArray.insert(postData, at: index)

						// TableViewの現在表示されているセルを更新する
						self.tableView.reloadData()
					}
				})

				// FIRDatabaseのobserveEventが上記コードにより登録されたため trueとする
				observing = true

			}
		} else {
			if observing == true {
				// ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
				// テーブルをクリアする
				postArray = []
				tableView.reloadData()
				// オブザーバーを削除する
				FIRDatabase.database().reference().removeAllObservers()

				// FIRDatabaseのobserveEventが上記コードにより解除されたため
				// falseとする
				observing = false
			}
		}
	}

	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postArray.count
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
		cell.setPostData(postData: postArray[indexPath.row])

		cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)

		return cell
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		print("DEBUG PRINT: Auto Layoutを使ってセルの高さを動的に変更する")
		return UITableViewAutomaticDimension
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath as IndexPath, animated: true)
	}

	func handleButton(sender: UIButton, event:UIEvent) {
		print("DEBUG_PRINT: likeボタンがタップされました。")

		// タップされたセルのインデックスを求める
		let touch = event.allTouches?.first
		let point = touch!.location(in: self.tableView)
		let indexPath = tableView.indexPathForRow(at: point)

		// 配列からタップされたインデックスのデータを取り出す
		let postData = postArray[indexPath!.row]

		// Firebaseに保存するデータの準備
		if let uid = FIRAuth.auth()?.currentUser?.uid {
			if postData.isLiked {
				// すでにいいねをしていた場合はいいねを解除するためIDを取り除く
				var index = -1
				for likeId in postData.likes {
					if likeId == uid {
						// 削除するためにインデックスを保持しておく
						index = postData.likes.index(of: likeId)!
						break
					}
				}
				postData.likes.remove(at: index)
			} else {
				postData.likes.append(uid)
			}

			// 増えたlikesをFirebaseに保存する
			let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!)
			let likes = ["likes": postData.likes]
			postRef.updateChildValues(likes)
		}
	}
}
