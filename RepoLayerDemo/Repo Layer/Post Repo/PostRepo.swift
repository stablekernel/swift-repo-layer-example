//
//  PostRepo.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 10/19/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation

protocol PostRepo {
	func listPosts(completion: ResultBlock<[Post]>)
	func getPost(id: Int, completion: ResultBlock<Post>)
	func createPost(title: String, body: String,
					completion: ResultBlock<Post>)
}

// An in-memory mock api repo
class MockPostRepo: PostRepo {

	// We can manually toggle if we want the mock repo to error out or not
	private var id = 0
	private var posts: [Int: Post] = [:]

	func listPosts(completion: ResultBlock<[Post]>) {
		let posts = self.posts.map { $1 }
		completion(.value(posts))
	}

	func getPost(id: Int, completion: ResultBlock<Post>) {

		if let post = posts[id] {
			// The post exists in memory
			completion(.value(post))
		} else {
			let error = NSError(domain: "Network error", code: 1, userInfo: nil)
			completion(.error(error))
		}
	}

	func createPost(title: String, body: String, completion: ResultBlock<Post>) {
		let post = Post(id: id, title: title, body: body)
		posts[id] = post
		id += 1 // Like a db would autoincrement unique identifiers
		completion(.value(post))
	}
}

class HttpPostRepo: PostRepo {

	private let http: HttpClient

	init(http: HttpClient) {
		self.http = http
	}

	func listPosts(completion: ResultBlock<[Post]>) {
		http.get("/posts", completion: completion)
	}

	func getPost(id: Int, completion: ResultBlock<Post>) {
		http.get("/posts/\(id)", completion: completion)
	}

	func createPost(title: String, body: String, completion: ResultBlock<Post>) {

		let httpBody: [String: Any] = [
			"title": title,
			"body": body
		]

		http.post("/posts", body: httpBody, completion: completion)
	}
}
