//
//  PostViewController.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/13/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyTextView: UITextView!

	private let postRepo: PostRepo
	private let postId: Int

	init(postRepo: PostRepo, postId: Int) {
		self.postRepo = postRepo
		self.postId = postId
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		loadPost()
	}

	private func loadPost() {
		postRepo.getPost(id: postId) { [weak self] result in
			switch result {
			case .value(let post):
				self?.update(with: post)
			case .error(let error):
				self?.presentPostLoadingError(error)
			}
		}
	}

	private func update(with post: Post) {
		titleLabel.text = post.title
		bodyTextView.text = post.body
	}

	private func presentPostLoadingError(_ error: Error) {
		// Present error
	}
}
