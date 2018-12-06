//
//  Post.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 10/22/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation
import CoreData

struct Post: Codable {
	let id: Int
	let title: String
	let body: String
}

class ManagedPost: NSManagedObject {
	@NSManaged var id: NSNumber
	@NSManaged var title: String
	@NSManaged var body: String
}
