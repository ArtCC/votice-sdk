//
//  StorageManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 7/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(forKey key: String, as type: T.Type) throws -> T?
    func delete(forKey key: String) throws
}

final class StorageManager: StorageManagerProtocol {
    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Init

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Functions

    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)

        userDefaults.set(data, forKey: key)
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        return try JSONDecoder().decode(type, from: data)
    }

    func delete(forKey key: String) throws {
        userDefaults.removeObject(forKey: key)
    }
}
