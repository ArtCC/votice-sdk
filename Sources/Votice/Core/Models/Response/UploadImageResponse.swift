//
//  UploadImageResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct UploadImageResponse: Codable, Sendable {
    let message: String
    let imageUrl: String
    let fileName: String
}
