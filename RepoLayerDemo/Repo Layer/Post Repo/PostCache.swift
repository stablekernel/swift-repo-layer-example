//
//  PostCache.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 10/22/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation
import CoreData

protocol PostCache {
	func getPost(id: Int) -> Post?
	func store(post: Post)
	func purgePost(id: Int)
}

// An in-memory post cache
class MockPostCache: PostCache {

	private var posts: [Int: Post] = [:]

	func getPost(id: Int) -> Post? {
		return posts[id]
	}

	func store(post: Post) {
		posts[post.id] = post
	}

	func purgePost(id: Int) {
		posts.removeValue(forKey: id)
	}
}

class UserDefaultsPostCache: PostCache {

	private let keyForPostList = "kPostListKey"
	private let defaults: UserDefaults
	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()

	init(defaults: UserDefaults) {
		self.defaults = defaults
	}

	// MARK: - PostCache

	func store(post: Post) {
		if let encoded = try? encoder.encode(post) {
			defaults.set(encoded, forKey: keyForPost(with: post.id))
			addPostToList(post)
		}
	}

	func getPost(id: Int) -> Post? {
		let data = defaults.object(forKey: keyForPost(with: id)) as? Data
		return data.flatMap { try? decoder.decode(Post.self, from: $0) }
	}

	private func addPostToList(_ post: Post) {
		// User defaults is not ideal for storing this list
		let data = defaults.object(forKey: keyForPostList) as? Data
		var ids: [Int] = data.flatMap { try? decoder.decode([Int].self, from: $0) } ?? []
		ids.append(post.id)
		if let encoded = try? encoder.encode(ids) {
			defaults.set(encoded, forKey: keyForPostList)
		}
	}

	func purgePost(id: Int) {
		defaults.removeObject(forKey: keyForPost(with: id))
	}

	// MARK: - Helpers

	private func keyForPost(with id: Int) -> String {
		return "kPostKey:\(id)"
	}
}

// This is pseudocode -- it has not been tested
class ManagedPostCache: PostCache {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func getPost(id: Int) -> Post? {
		let request = NSFetchRequest<ManagedPost>(entityName: "ManagedPost")
		request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))

		guard let result = try? context.fetch(request), let cachedPost = result.first else {
			return nil
		}

		// I generally prefer to work with immutable structs
		// but it's perfectly acceptable to interact directly
		// with NSManagedObject subclasses
		let immutablePost = Post(
			id: cachedPost.id.intValue,
			title: cachedPost.title,
			body: cachedPost.body)

		return immutablePost
	}

	func store(post: Post) {
		let entity = NSEntityDescription.insertNewObject(forEntityName: "ManagedPost", into: context) as! ManagedPost
		entity.id = NSNumber(value: post.id)
		entity.title = post.title
		entity.body = post.body
		context.insert(entity)
	}

	func purgePost(id: Int) {
		let request = NSFetchRequest<ManagedPost>(entityName: "ManagedPost")
		request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))

		guard let result = try? context.fetch(request), let cachedPost = result.first else {
			return
		}

		context.delete(cachedPost)
	}
}
