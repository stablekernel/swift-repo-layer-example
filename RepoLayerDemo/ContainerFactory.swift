//
//  ContainerFactory.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/13/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation
import Swinject
import CoreData

class ContainerFactory {

	static func container(for environment: Environment) -> Container {
		let factory = ContainerFactory()

		switch environment {
		case .mock:
			return factory.makeMockContainer()
		case .production:
			return factory.makeDefaultContainer()
		}
	}

	private func makeDefaultContainer() -> Container {
		let container = Container()

		container.register(UserDefaults.self) { _ in
			return .standard
		}

		container.register(PostCache.self) { r in
			let defaults = r.resolve(UserDefaults.self)!
			return UserDefaultsPostCache(defaults: defaults)
		}

		container.register(PostRepo.self) { r in
			let cache = r.resolve(PostCache.self)!
			let api = MockPostRepo()
			return PostRepoCacheDecorator(inner: api, cache: cache)
		}

		return container
	}

	private func makeMockContainer() -> Container {
		let container = Container()

		container.register(PostCache.self) { r in
			return MockPostCache()
		}

		container.register(PostRepo.self) { r in
			let cache = r.resolve(PostCache.self)!
			let api = MockPostRepo()
			return PostRepoCacheDecorator(inner: api, cache: cache)
		}

		return container
	}
}
