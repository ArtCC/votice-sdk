//
//  DeviceManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(WatchKit)
import WatchKit
#elseif canImport(TVUIKit)
import TVUIKit
#endif

protocol DeviceManagerProtocol: Sendable {
    // MARK: - Properties

    var deviceId: String { get }
    var platform: String { get }
    var language: String { get }

    // MARK: - Public functions

    func generateNewDeviceId() -> String
    func resetDeviceId()
}

final class DeviceManager: DeviceManagerProtocol {
    // MARK: - Properties

    static let shared = DeviceManager()

    private nonisolated(unsafe) let userDefaults: UserDefaults
    private let deviceIdKey = "VoticeSDK_DeviceId"
    private let lock = NSLock()

    // MARK: - Public

    var deviceId: String {
        lock.withLock {
            let currentId = getCurrentDeviceId()
            if currentId.isEmpty {
                return generateNewDeviceId()
            }
            return currentId
        }
    }
    var platform: String {
#if os(iOS)
#if targetEnvironment(macCatalyst)
        return "macCatalyst"
#else
        return UIDevice.current.userInterfaceIdiom == .pad ? "iPadOS" : "iOS"
#endif
#elseif os(macOS)
        return "macOS"
#elseif os(watchOS)
        return "watchOS"
#elseif os(tvOS)
        return "tvOS"
#elseif os(visionOS)
        return "visionOS"
#else
        return "Unknown"
#endif
    }
    var language: String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }

    // MARK: - Init

    internal init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        // Ensure we have a device ID on initialization (without locks to avoid deadlock)
        if (userDefaults.string(forKey: deviceIdKey) ?? "").isEmpty {
            let newDeviceId = UUID().uuidString
            userDefaults.set(newDeviceId, forKey: deviceIdKey)
            userDefaults.synchronize()

            LogManager.shared.devLog(.info, "Generated initial device ID: \(newDeviceId)")
        }
    }

    // MARK: - Functions

    @discardableResult
    func generateNewDeviceId() -> String {
        let newDeviceId = UUID().uuidString
        userDefaults.set(newDeviceId, forKey: deviceIdKey)
        userDefaults.synchronize()

        LogManager.shared.devLog(.info, "Generated new device ID: \(newDeviceId)")

        return newDeviceId
    }

    func resetDeviceId() {
        lock.withLock {
            userDefaults.removeObject(forKey: deviceIdKey)
            userDefaults.synchronize()

            LogManager.shared.devLog(.info, "Device ID reset")
        }
    }

    // MARK: - Private

    private func getCurrentDeviceId() -> String {
        return userDefaults.string(forKey: deviceIdKey) ?? ""
    }
}
