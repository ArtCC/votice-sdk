//
//  VoticeAlertEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 30/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoticeAlertEntity {
    // MARK: - Properties

    let type: VoticeAlertType
    let title: String
    let message: String
    let primaryButton: VoticeAlertButton
    let secondaryButton: VoticeAlertButton?

    // MARK: - Init

    init(type: VoticeAlertType = .error,
         title: String,
         message: String,
         primaryButton: VoticeAlertButton? = nil,
         secondaryButton: VoticeAlertButton? = nil) {
        self.type = type
        self.title = title
        self.message = message
        self.primaryButton = primaryButton ?? VoticeAlertButton(title: "OK", style: .default)
        self.secondaryButton = secondaryButton
    }

    // MARK: - Convenience Initializers

    static func error(title: String = "Error",
                      message: String,
                      okAction: @escaping () -> Void = {}) -> VoticeAlertEntity {
        VoticeAlertEntity(
            type: .error,
            title: title,
            message: message,
            primaryButton: VoticeAlertButton(title: "OK", style: .destructive, action: okAction)
        )
    }

    static func success(title: String = "Success",
                        message: String,
                        okAction: @escaping () -> Void = {}) -> VoticeAlertEntity {
        VoticeAlertEntity(
            type: .success,
            title: title,
            message: message,
            primaryButton: VoticeAlertButton(title: "OK", style: .primary, action: okAction)
        )
    }

    static func warning(title: String = "Warning",
                        message: String,
                        okAction: @escaping () -> Void = {},
                        cancelAction: @escaping () -> Void = {}) -> VoticeAlertEntity {
        VoticeAlertEntity(
            type: .warning,
            title: title,
            message: message,
            primaryButton: VoticeAlertButton(title: "OK", style: .primary, action: okAction),
            secondaryButton: VoticeAlertButton(title: "Cancel", style: .default, action: cancelAction)
        )
    }

    static func info(title: String = "Info",
                     message: String,
                     okAction: @escaping () -> Void = {}) -> VoticeAlertEntity {
        VoticeAlertEntity(
            type: .info,
            title: title,
            message: message,
            primaryButton: VoticeAlertButton(title: "OK", style: .default, action: okAction)
        )
    }
}
