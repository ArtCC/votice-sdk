//
//  VersionRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VersionRequest: Codable, Sendable {
    let version: String
    let buildNumber: String
    let platform: String
}
