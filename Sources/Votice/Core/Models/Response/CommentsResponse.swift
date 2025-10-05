//
//  CommentsResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct CommentsResponse: Codable, Sendable {
    // MARK: - Properties

    let comments: [CommentEntity]
    let count: Int
    let nextPageToken: NextPageResponse?
    let nextPageTokenString: String?

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case comments
        case count
        case nextPageToken
    }

    // MARK: - Init

    public init(
        comments: [CommentEntity],
        count: Int,
        nextPageToken: NextPageResponse? = nil,
        nextPageTokenString: String? = nil
    ) {
        self.comments = comments
        self.count = count
        self.nextPageToken = nextPageToken
        self.nextPageTokenString = nextPageTokenString
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        comments = try container.decode([CommentEntity].self, forKey: .comments)
        count = try container.decode(Int.self, forKey: .count)

        if let nextPageTokenStr = try? container.decode(String.self, forKey: .nextPageToken) {
            nextPageTokenString = nextPageTokenStr
            nextPageToken = nil
        } else {
            nextPageTokenString = nil
            nextPageToken = try? container.decode(NextPageResponse.self, forKey: .nextPageToken)
        }
    }
}
