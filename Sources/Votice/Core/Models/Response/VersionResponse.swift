//
//  VersionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VersionResponse: Codable, Sendable {
    let message: String
    let versionEntry: VersionItemResponse
}
