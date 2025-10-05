//
//  UploadImageRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct UploadImageRequest: Codable, Sendable {
    let imageData: String
    let fileName: String
    let mimeType: String
}
