//
//  AppStorage.swift
//
//
//  Created by devonly on 2021/12/08.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        do {
            let result = try JSONDecoder().decode([Element].self, from: data)
            self = result
        } catch {
            print(error)
            return nil
        }
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

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
