//
//  Config.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/13/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation

enum Environment {
	case mock, production
}

struct Config {

	#if MOCK
	let environment: Environment = .mock
	#else
	let environment: Environment = .production
	#endif
}
