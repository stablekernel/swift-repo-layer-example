//
//  PostRepoDecorator.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/15/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation

protocol PostRepoDecorator: PostRepo {
	var inner: PostRepo { get }
}

extension PostRepoDecorator {
	func listPosts(completion: ResultBlock<[Post]>) {
		inner.listPosts(completion: completion)
	}

	func getPost(id: Int, completion: ResultBlock<Post>) {
		inner.getPost(id: id, completion: completion)
	}

	func createPost(title: String, body: String, completion: ResultBlock<Post>) {
		inner.createPost(title: title, body: body, completion: completion)
	}
}
