//
//  NetworkManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import CryptoKit

struct NetworkManager: NetworkManagerProtocol {
    // MARK: - Properties

    static let shared = NetworkManager()

    private let session: URLSession
    private let configurationManager: ConfigurationManagerProtocol

    // MARK: - Initialization

    init(session: URLSession = .shared,
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared) {
        self.session = session
        self.configurationManager = configurationManager
    }

    // MARK: - Public

    func request<T: Codable & Sendable>(
        endpoint: NetworkEndpoint,
        responseType: T.Type
    ) async throws -> T {
        let data = try await performRequest(endpoint: endpoint)

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(responseType, from: data)

            LogManager.shared.devLog(.success, "Successfully decoded response for \(endpoint.path)")
            return result
        } catch {
            LogManager.shared.devLog(.error, "Decoding error for \(endpoint.path): \(error.localizedDescription)")
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }

    func request(endpoint: NetworkEndpoint) async throws {
        _ = try await performRequest(endpoint: endpoint)
        LogManager.shared.devLog(.success, "Request completed successfully for \(endpoint.path)")
    }

    // MARK: - Private

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    private func performRequest(endpoint: NetworkEndpoint) async throws -> Data {
        try configurationManager.validateConfiguration()

        let baseURL = configurationManager.baseURL
        let apiKey = configurationManager.apiKey
        let apiSecret = configurationManager.apiSecret

        guard let url = URL(string: baseURL + endpoint.path) else {
            LogManager.shared.devLog(.error, "Invalid URL: \(baseURL + endpoint.path)")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add API key
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        // Generate HMAC signature if we have body
        if let body = endpoint.body {
            let signature = generateHMACSignature(data: body, secret: apiSecret)
            request.setValue(signature, forHTTPHeaderField: "x-signature")
        }

        // Add custom headers
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        LogManager.shared.devLog(.request, "Making request to \(url.absoluteString)")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                LogManager.shared.devLog(.error, "Invalid response type")
                throw NetworkError.invalidResponse
            }

            LogManager.shared.devLog(.info, "Response status code: \(httpResponse.statusCode)")

            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                LogManager.shared.devLog(.success, "Request successful", utf8Data: data)
                return data
            case 401:
                LogManager.shared.devLog(.error, "Authentication error", utf8Data: data)
                throw NetworkError.authenticationError
            case 400...499:
                let errorMessage = String(data: data, encoding: .utf8) ?? "Client error"
                LogManager.shared.devLog(.error, "Client error: \(errorMessage)")
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            case 500...599:
                let errorMessage = String(data: data, encoding: .utf8) ?? "Server error"
                LogManager.shared.devLog(.error, "Server error: \(errorMessage)")
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            default:
                LogManager.shared.devLog(.error, "Unexpected status code: \(httpResponse.statusCode)")
                throw NetworkError.serverError(httpResponse.statusCode, "Unexpected error")
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            LogManager.shared.devLog(.error, "Network request failed: \(error.localizedDescription)")
            throw NetworkError.unknownError(error.localizedDescription)
        }
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length

    private func generateHMACSignature(data: Data, secret: String) -> String {
        let key = SymmetricKey(data: Data(secret.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: data, using: key)
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
}
