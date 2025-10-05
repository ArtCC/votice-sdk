//
//  AlertManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 1/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

@MainActor
final class AlertManager: ObservableObject {
    // MARK: - Properties

    @Published var currentAlert: VoticeAlertEntity?
    @Published var isShowingAlert = false

    private let lock = NSLock()

    // MARK: - Init

    private init() {}

    // MARK: - Public functions

    func showAlert(_ alert: VoticeAlertEntity) {
        lock.lock()

        defer {
            lock.unlock()
        }

        currentAlert = alert

        isShowingAlert = true

        LogManager.shared.devLog(.info, "AlertManager: showing alert - \(alert.title)")
    }

    func showError(
        title: String? = nil,
        message: String,
        okAction: @escaping () -> Void = {}
    ) {
        let errorTitle = title ?? TextManager.shared.texts.error
        let alert = VoticeAlertEntity.error(title: errorTitle, message: message, okAction: okAction)

        showAlert(alert)
    }

    func showSuccess(
        title: String? = nil,
        message: String,
        okAction: @escaping () -> Void = {}
    ) {
        let successTitle = title ?? TextManager.shared.texts.success
        let alert = VoticeAlertEntity.success(title: successTitle, message: message, okAction: okAction)

        showAlert(alert)
    }

    func showWarning(
        title: String? = nil,
        message: String,
        okAction: @escaping () -> Void = {},
        cancelAction: @escaping () -> Void = {}
    ) {
        let warningTitle = title ?? TextManager.shared.texts.warning
        let alert = VoticeAlertEntity.warning(
            title: warningTitle,
            message: message,
            okAction: okAction,
            cancelAction: cancelAction
        )

        showAlert(alert)
    }

    func showInfo(
        title: String? = nil,
        message: String,
        okAction: @escaping () -> Void = {}
    ) {
        let infoTitle = title ?? TextManager.shared.texts.info
        let alert = VoticeAlertEntity.info(title: infoTitle, message: message, okAction: okAction)

        showAlert(alert)
    }

    func dismissAlert() {
        lock.lock()

        defer {
            lock.unlock()
        }

        isShowingAlert = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentAlert = nil
        }

        LogManager.shared.devLog(.info, "AlertManager: alert dismissed")
    }

    // MARK: - Convenience functions

    func handleError(_ error: Error, title: String? = nil, okAction: @escaping () -> Void = {}) {
        showError(title: title, message: error.localizedDescription, okAction: okAction)
    }
}
