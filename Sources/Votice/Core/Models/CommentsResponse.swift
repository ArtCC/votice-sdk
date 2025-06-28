//
//  CommentsResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CommentsResponse: Codable, Sendable {
    let comments: [CommentEntity]
}
