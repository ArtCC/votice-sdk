//
//  DeviceManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol DeviceManagerProtocol: Sendable {
    var deviceId: String { get }
    var platform: String { get }
    var language: String { get }

    func generateNewDeviceId() -> String
    func resetDeviceId()
}
