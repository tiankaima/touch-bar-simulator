//
//  SwiftExtension.swift
//  Touch Bar Simulator
//
//  Created by Tiankai Ma on 2023/2/26.
//  Copyright © 2023 Sindre Sorhus. All rights reserved.
//

import Foundation

// Credit: https://stackoverflow.com/a/65598711/18417441
// License: CC-BY-SA 4.0
extension Array: RawRepresentable where Element: Codable {
	public init?(rawValue: String) {
		guard let data = rawValue.data(using: .utf8),
			  let result = try? JSONDecoder().decode([Element].self, from: data)
		else {
			return nil
		}
		self = result
	}
	
	public var rawValue: String {
		guard let data = try? JSONEncoder().encode(self),
			  let result = String(data: data, encoding: .utf8)
		else {
			return "[]"
		}
		return result
	}
}
