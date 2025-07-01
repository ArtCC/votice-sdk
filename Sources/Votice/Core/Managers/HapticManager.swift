//
//  HapticManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 30/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

#if os(iOS)
import UIKit
#endif
import Foundation

protocol HapticManagerProtocol: Sendable {
    func lightImpact()
    func mediumImpact()
    func heavyImpact()
    func success()
    func warning()
    func error()
}

final class HapticManager: HapticManagerProtocol, @unchecked Sendable {
    // MARK: - Properties

    static let shared = HapticManager()

#if os(iOS)
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
#endif

    // MARK: - Init

    private init() {
#if os(iOS)
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        notificationGenerator.prepare()
#endif
    }

    // MARK: - Public functions

    func lightImpact() {
#if os(iOS)
        lightImpactGenerator.impactOccurred()
#endif
    }

    func mediumImpact() {
#if os(iOS)
        mediumImpactGenerator.impactOccurred()
#endif
    }

    func heavyImpact() {
#if os(iOS)
        heavyImpactGenerator.impactOccurred()
#endif
    }

    func success() {
#if os(iOS)
        notificationGenerator.notificationOccurred(.success)
#endif
    }

    func warning() {
#if os(iOS)
        notificationGenerator.notificationOccurred(.warning)
#endif
    }

    func error() {
#if os(iOS)
        notificationGenerator.notificationOccurred(.error)
#endif
    }
}
