//
//  HttpClient.swift
//  RepoLayerDemo
//
//  Created by Ian MacCallum on 11/13/18.
//  Copyright © 2018 Ian MacCallum. All rights reserved.
//

import Foundation

enum Result<T> {
	case value(T)
	case error(Error)
}

typealias ResultBlock<T> = (Result<T>) -> Void

protocol HttpClient {
	func get<T: Codable>(_ path: String, completion: ResultBlock<T>)
	func post<T: Codable>(_ path: String, body: [String: Any],
						  completion: ResultBlock<T>)
}
