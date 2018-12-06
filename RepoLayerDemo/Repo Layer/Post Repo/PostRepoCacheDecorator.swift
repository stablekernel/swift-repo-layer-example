//
//  PostRepoCacheDecorator.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 10/22/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation

class PostRepoCacheDecorator: PostRepoDecorator {

	private let cache: PostCache
	let inner: PostRepo

	init(inner: PostRepo, cache: PostCache) {
		self.inner = inner
		self.cache = cache
	}

	func listPosts(completion: ResultBlock<[Post]>) {
		// Lets not worry about caching the entire post list now

		inner.listPosts { result in
			if case .value(let posts) = result {
				posts.forEach { cache.store(post: $0) }
			}

			completion(result)
		}
	}

	func getPost(id: Int, completion: ResultBlock<Post>) {

		guard let cachedPost = cache.getPost(id: id) else {

			// Hit the network to get posts
			return inner.getPost(id: id) { result in

				// Cache posts from network for next time
				if case .value(let post) = result {
					cache.store(post: post)
				}

				// Forward the result
				completion(result)
			}
		}

		completion(.value(cachedPost))
	}

	func createPost(title: String, body: String,
					completion: ResultBlock<Post>) {

		inner.createPost(title: title, body: body) { result in

			// Cache the newly created post
			if case .value(let createdPost) = result {
				cache.store(post: createdPost)
			}

			// Forward the response
			completion(result)
		}
	}
}
