//
//  VoticeAlertButton.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoticeAlertButton {
    // MARK: - Properties

    let title: String
    let action: () -> Void
    let style: VoticeAlertButtonStyle

    // MARK: - Init

    init(title: String, style: VoticeAlertButtonStyle = .default, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.action = action
    }
}
