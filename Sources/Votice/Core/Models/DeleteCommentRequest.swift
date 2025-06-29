//
//  DeleteCommentRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct DeleteCommentRequest: Codable, Sendable {
    let commentId: String
    let deviceId: String
}
