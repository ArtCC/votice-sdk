//
//  VersionItemResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VersionItemResponse: Codable, Sendable {
    let appId: String
    let version: String
    let platform: String
    let buildNumber: String
    let firstReported: String
    let lastReported: String
    let reportCount: Int
}
