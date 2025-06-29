//
//  CreateCommentRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CreateCommentRequest: Codable, Sendable {
    let suggestionId: String
    let text: String
    let deviceId: String
    let nickname: String?
}
