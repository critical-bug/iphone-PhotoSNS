//
//  PostData.swift
//  PhotoSNS
//
//  Created by 	 on 02/16木.
//  Copyright © 2017年 critical-bug. All rights reserved.
//

import Foundation
import Firebase

class PostData: NSObject {
	var id: String?
	var image: UIImage?
	var imageString: String?
	var name: String?
	var caption: String?
	var date: NSDate?
	var likes: [String] = []
	var isLiked: Bool = false

	init(snapshot: FIRDataSnapshot, myId: String) {
		self.id = snapshot.key

		let valueDictionary = snapshot.value as! [String: AnyObject]

		imageString = valueDictionary["image"] as? String
		image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)

		self.name = valueDictionary["name"] as? String

		self.caption = valueDictionary["caption"] as? String

		let time = valueDictionary["time"] as? String
		self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)

		if let likes = valueDictionary["likes"] as? [String] {
			self.likes = likes
		}

		for likeId in self.likes {
			if likeId == myId {
				self.isLiked = true
				break
			}
		}
	}
}
