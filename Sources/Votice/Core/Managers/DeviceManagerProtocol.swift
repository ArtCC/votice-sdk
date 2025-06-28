//
//  DeviceManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol DeviceManagerProtocol: Sendable {
    // MARK: - Properties

    var deviceId: String { get }
    var platform: String { get }
    var language: String { get }

    // MARK: - Public functions

    func generateNewDeviceId() -> String
    func resetDeviceId()
}
