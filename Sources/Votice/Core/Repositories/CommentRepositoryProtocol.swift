//
//  CommentRepositoryProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol CommentRepositoryProtocol: Sendable {
    func createComment(request: CreateCommentRequest) async throws -> CreateCommentResponse
    func fetchComments(request: FetchCommentsRequest) async throws -> FetchCommentsResponse
}
