//
//  VoticeAlert.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 1/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct VoticeAlert: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    let alert: VoticeAlertEntity
    let isPresented: Binding<Bool>

    // MARK: - View

    var body: some View {
        ZStack {
            if isPresented.wrappedValue {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissAlert()
                    }
                alertCard
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isPresented.wrappedValue)
    }
}

// MARK: - Private

private extension VoticeAlert {
    // MARK: - Properties

    var alertCard: some View {
        VStack(spacing: 0) {
            headerSection
            contentSection
            buttonsSection
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(theme.spacing.md)
        .frame(maxWidth: 320)
    }

    var headerSection: some View {
        VStack(spacing: theme.spacing.sm) {
            ZStack {
                Circle()
                    .fill(alertTypeColor.opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: alertTypeIcon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(alertTypeColor)
            }
            Text(alert.title)
                .font(theme.typography.title3)
                .fontWeight(.medium)
                .foregroundColor(theme.colors.onSurface)
                .multilineTextAlignment(.center)
        }
        .padding(.top, theme.spacing.md)
        .padding(.horizontal, theme.spacing.md)
    }

    var contentSection: some View {
        VStack(spacing: theme.spacing.md) {
            Text(alert.message)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(theme.spacing.md)
    }

    var buttonsSection: some View {
        VStack(spacing: theme.spacing.sm) {
            Divider()
                .background(theme.colors.secondary.opacity(0.2))
            if let secondaryButton = alert.secondaryButton {
                HStack(spacing: theme.spacing.md) {
                    alertButton(secondaryButton, isPrimary: false)
                    alertButton(alert.primaryButton, isPrimary: true)
                }
                .padding(.horizontal, theme.spacing.md)
                .padding(.bottom, theme.spacing.md)
            } else {
                alertButton(alert.primaryButton, isPrimary: true)
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.bottom, theme.spacing.md)
            }
        }
    }

    var alertTypeColor: Color {
        switch alert.type {
        case .success:
            return theme.colors.success
        case .warning:
            return theme.colors.warning
        case .error:
            return theme.colors.error
        case .info:
            return theme.colors.primary
        }
    }

    var alertTypeIcon: String {
        switch alert.type {
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.circle.fill"
        case .info:
            return "info.circle.fill"
        }
    }

    // MARK: - Functions

    func alertButton(_ button: VoticeAlertButton, isPrimary: Bool) -> some View {
        Button {
            HapticManager.shared.lightImpact()

            dismissAlert()

            button.action()
        } label: {
            Text(button.title)
                .font(theme.typography.callout)
                .fontWeight(isPrimary ? .semibold : .medium)
                .foregroundColor(buttonTextColor(for: button.style, isPrimary: isPrimary))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                        .fill(buttonBackgroundColor(for: button.style, isPrimary: isPrimary))
                )
        }
        .buttonStyle(.plain)
    }

    func buttonTextColor(for style: VoticeAlertButtonStyle, isPrimary: Bool) -> Color {
        switch style {
        case .primary:
            return .white
        case .destructive:
            return isPrimary ? .white : theme.colors.error
        case .default:
            return theme.colors.primary
        }
    }

    func buttonBackgroundColor(for style: VoticeAlertButtonStyle, isPrimary: Bool) -> Color {
        switch style {
        case .primary:
            return theme.colors.primary
        case .destructive:
            return isPrimary ? theme.colors.error : theme.colors.error.opacity(0.1)
        case .default:
            return isPrimary ? theme.colors.primary.opacity(0.1) : Color.clear
        }
    }

    func dismissAlert() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isPresented.wrappedValue = false
        }
    }
}
