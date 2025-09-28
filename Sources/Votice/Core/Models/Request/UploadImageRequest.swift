//
//  UploadImageRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct UploadImageRequest: Codable, Sendable {
    let imageData: Data
    let fileName: String
}
