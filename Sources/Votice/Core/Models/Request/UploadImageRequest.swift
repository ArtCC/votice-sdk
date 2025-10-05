//
//  UploadImageRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct UploadImageRequest: Codable, Sendable {
    public let imageData: String
    public let fileName: String
    public let mimeType: String
}
