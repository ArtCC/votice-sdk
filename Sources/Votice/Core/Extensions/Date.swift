//
//  Date.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

extension Date {
    static func from(iso8601String: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return formatter.date(from: iso8601String)
    }

    static func formatFromISOString(_ isoString: String) -> String? {
        guard let date = Date.from(iso8601String: isoString) else {
            return nil
        }

        return date.formattedForDevice()
    }

    // MARK: - Private

    private func formattedForDevice() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true

        return formatter.string(from: self)
    }
}
