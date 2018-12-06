//
//  Store.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 10/19/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation
import Swinject

protocol Store {
	var postRepo: PostRepo { get }
}

class DefaultStore: Store {

	private let container: Container

	lazy var postRepo: PostRepo = container.resolve(PostRepo.self)!

	init(container: Container) {
		self.container = container
	}
}
