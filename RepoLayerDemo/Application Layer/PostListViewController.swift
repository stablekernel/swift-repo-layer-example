//
//  PostListViewController.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/13/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	private let postRepo: PostRepo
	private var posts: [Post] = []

	init(postRepo: PostRepo) {
		self.postRepo = postRepo
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostPressed(_:)))
		navigationItem.rightBarButtonItem = addButton

		loadPosts()
	}

	private func loadPosts() {
		postRepo.listPosts { [weak self] result in
			switch result {
			case .value(let posts):
				self?.posts = posts
			case .error(let error):
				self?.presentPostLoadingError(error)
			}
		}
	}

	private func createPost(title: String, body: String) {
		postRepo.createPost(title: title, body: body) { [weak self] result in
			switch result {
			case .value(let post):
				self?.posts.append(post)
				self?.tableView.reloadData()
			case .error(let error):
				self?.presentPostCreationError(error)
			}
		}
	}

	// MARK: - Actions
	@objc func addPostPressed(_ sender: UIBarButtonItem) {
		presentAddPostAlertController()
	}

	// MARK: - Presentation
	private func presentPostLoadingError(_ error: Error) {
		// Present some error
	}

	private func presentPostCreationError(_ error: Error) {
		// Present some error
	}

	private func presentAddPostAlertController() {
		let controller = UIAlertController(title: "Create Post",
										   message: "Enter title and body",
										   preferredStyle: .alert)

		controller.addTextField { textField in
			textField.placeholder = "title"
		}

		controller.addTextField { textField in
			textField.placeholder = "body"
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
			let title = controller.textFields?[0].text ?? ""
			let body = controller.textFields?[1].text ?? ""
			self?.createPost(title: title, body: body)
		}

		controller.addAction(cancelAction)
		controller.addAction(createAction)

		present(controller, animated: true, completion: nil)
	}

	private func presentViewPost(_ post: Post) {
		// We will not pass the entire post object
		// so the get function must be called
		let postViewController = PostViewController(postRepo: postRepo, postId: post.id)
		navigationController?.pushViewController(postViewController, animated: true)
	}
}

extension PostListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let post = posts[indexPath.row]
		cell.textLabel?.text = post.title
		return cell
	}
}

extension PostListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let post = posts[indexPath.row]
		presentViewPost(post)
	}
}
