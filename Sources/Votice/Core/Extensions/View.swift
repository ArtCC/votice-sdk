//
//  View.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - View Extensions

extension View {
    // MARK: - Properties

    var hasNotchOrDynamicIsland: Bool {
        guard let window = UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else {
            return false
        }

        return window.safeAreaInsets.top >= 44
    }

    // MARK: - Public functions

    func voticeAlert(isPresented: Binding<Bool>, alert: VoticeAlertEntity) -> some View {
        self.overlay(
            VoticeAlert(alert: alert, isPresented: isPresented)
        )
    }

    func voticeTheme(_ theme: VoticeTheme) -> some View {
        environment(\.voticeTheme, theme)
    }
}

// MARK: - Liquid Glass View Extensions

extension View {
    /// Applies an adaptive background that switches between Liquid Glass and classic design
    /// - Parameters:
    ///   - useLiquidGlass: Whether to use Liquid Glass effect
    ///   - cornerRadius: Corner radius for the shape
    ///   - fillColor: Fallback color for classic design
    ///   - isInteractive: Whether the glass should react to interactions
    /// - Returns: View with adaptive background
    @ViewBuilder
    func adaptiveGlassBackground(
        useLiquidGlass: Bool,
        cornerRadius: CGFloat,
        fillColor: Color,
        isInteractive: Bool = false
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, *), useLiquidGlass {
#if !os(tvOS)
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .glassEffect(
                        isInteractive ? .regular.interactive() : .regular,
                        in: .rect(cornerRadius: cornerRadius)
                    )
            }
#else
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
            }
#endif
        } else {
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
            }
        }
    }

    /// Applies an adaptive background with shadow for classic design
    /// - Parameters:
    ///   - useLiquidGlass: Whether to use Liquid Glass effect
    ///   - cornerRadius: Corner radius for the shape
    ///   - fillColor: Fallback color for classic design
    ///   - shadowColor: Shadow color for classic design
    ///   - shadowRadius: Shadow radius for classic design
    ///   - shadowX: Shadow X offset for classic design
    ///   - shadowY: Shadow Y offset for classic design
    ///   - isInteractive: Whether the glass should react to interactions
    /// - Returns: View with adaptive background and optional shadow
    @ViewBuilder
    func adaptiveGlassBackgroundWithShadow(
        useLiquidGlass: Bool,
        cornerRadius: CGFloat,
        fillColor: Color,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: CGFloat = 2,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 1,
        isInteractive: Bool = false
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, *), useLiquidGlass {
#if !os(tvOS)
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .glassEffect(
                        isInteractive ? .regular.interactive() : .regular,
                        in: .rect(cornerRadius: cornerRadius)
                    )
            }
#else
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
#endif
        } else {
            self.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
        }
    }

    /// Applies an adaptive circular background for buttons (like FAB)
    /// - Parameters:
    ///   - useLiquidGlass: Whether to use Liquid Glass effect
    ///   - fillColor: Fallback color for classic design
    ///   - shadowColor: Shadow color for classic design
    ///   - shadowRadius: Shadow radius for classic design
    ///   - shadowX: Shadow X offset for classic design
    ///   - shadowY: Shadow Y offset for classic design
    ///   - isInteractive: Whether the glass should react to interactions
    /// - Returns: View with adaptive circular background
    @ViewBuilder
    func adaptiveCircularGlassBackground(
        useLiquidGlass: Bool,
        fillColor: Color,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: CGFloat = 2,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 1,
        isInteractive: Bool = true
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, *), useLiquidGlass {
#if !os(tvOS)
            self.background {
                Circle()
                    .fill(fillColor.opacity(0.75))
                    .glassEffect(
                        isInteractive ? .regular.interactive() : .regular,
                        in: .circle
                    )
            }
#else
            self.background {
                Circle()
                    .fill(fillColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
#endif
        } else {
            self.background {
                Circle()
                    .fill(fillColor)
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
        }
    }

    /// Applies an adaptive rectangle background (for headers, toolbars, etc.)
    /// - Parameters:
    ///   - useLiquidGlass: Whether to use Liquid Glass effect
    ///   - fillColor: Fallback color for classic design
    ///   - shadowColor: Shadow color for classic design
    ///   - shadowRadius: Shadow radius for classic design
    ///   - shadowX: Shadow X offset for classic design
    ///   - shadowY: Shadow Y offset for classic design
    /// - Returns: View with adaptive rectangle background
    @ViewBuilder
    func adaptiveRectangleGlassBackground(
        useLiquidGlass: Bool,
        fillColor: Color,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: CGFloat = 2,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 1
    ) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, *), useLiquidGlass {
#if !os(tvOS)
            self.background {
                Rectangle()
                    .fill(fillColor)
                    .glassEffect(.regular, in: .rect)
            }
#else
            self.background {
                fillColor
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
#endif
        } else {
            self.background {
                fillColor
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            }
        }
    }
}
