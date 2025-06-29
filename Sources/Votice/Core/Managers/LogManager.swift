//
//  LogManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum LogManagerType {
    case canceled
    case error
    case finished
    case info
    case request
    case success
    case warning
}

protocol LogManagerProtocol: Sendable {
    func devLog(_ logType: LogManagerType,
                _ message: String,
                utf8Data: Data?,
                ignoreFunctionName: Bool,
                function: String)
    func devLog(_ logType: LogManagerType,
                _ message: String,
                userInfo: [AnyHashable: Any],
                function: String)
}

struct LogManager: LogManagerProtocol {
    // MARK: - Properties

    static var debug = false

    static let shared = Self()

    // MARK: - Public

    func devLog(_ logType: LogManagerType,
                _ message: String,
                utf8Data: Data? = nil,
                ignoreFunctionName: Bool = true,
                function: String = #function) {
        let functionName = ignoreFunctionName ? "" : "\(function): "

        if let data = utf8Data, let dataString = String(data: data, encoding: .utf8) {
            let dataMessage = (dataString.isEmpty) ? "No data" : dataString

            log(logType, "\(functionName)\(message)\n\(dataMessage)")
        } else {
            log(logType, "\(functionName)\(message)")
        }
    }

    func devLog(_ logType: LogManagerType,
                _ message: String,
                userInfo: [AnyHashable: Any],
                function: String = #function) {
        if let data = try? JSONSerialization.data(withJSONObject: userInfo, options: [.prettyPrinted]),
           let jsonString = String(data: data, encoding: .utf8) {

            log(logType, "\(function): \(message)\n\(jsonString)")
        } else {
            log(logType, "\(function): \(message)\n\(userInfo)")
        }
    }
}

// MARK: - Private

private extension LogManager {
    func log(_ logType: LogManagerType, _ message: String) {
        if Self.debug {
            switch logType {
            case .canceled:
                print("❌ Cancelled: \(message)")
            case .error:
                print("💣 Error: \(message)")
            case .finished:
                print("🏁 Finished: \(message)")
            case .info:
                print("ℹ️ Info: \(message)")
            case .request:
                print("🚀 Request: \(message)")
            case .success:
                print("✅ Success: \(message)")
            case .warning:
                print("⚠️ Warning: \(message)")
            }
        }
    }
}
