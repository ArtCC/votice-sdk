//
//  CreateCommentResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct CreateCommentResponse: Codable, Sendable {
    public let message: String
    public let comment: CommentEntity
}
