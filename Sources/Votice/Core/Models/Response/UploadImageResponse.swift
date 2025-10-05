//
//  UploadImageResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct UploadImageResponse: Codable, Sendable {
    public let message: String
    public let imageUrl: String
    public let fileName: String
}
