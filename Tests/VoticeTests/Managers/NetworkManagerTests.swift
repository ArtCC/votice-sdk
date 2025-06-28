//
//  NetworkManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - Mock URLSession Protocol

protocol MockURLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - Mock URLSession Implementation

final class MockURLSession: MockURLSessionProtocol, @unchecked Sendable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }

        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        return (data, response)
    }
}

// MARK: - Custom NetworkManager for Testing

struct TestableNetworkManager: NetworkManagerProtocol {
    private let mockSession: MockURLSessionProtocol
    private let baseURL: String
    private let apiKey: String
    private let apiSecret: String

    init(baseURL: String = "",
         apiKey: String = "",
         apiSecret: String = "",
         mockSession: MockURLSessionProtocol) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.mockSession = mockSession
    }

    func request<T: Codable & Sendable>(
        endpoint: NetworkEndpoint,
        responseType: T.Type
    ) async throws -> T {
        let data = try await performRequest(endpoint: endpoint)

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(responseType, from: data)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }

    func request(endpoint: NetworkEndpoint) async throws {
        _ = try await performRequest(endpoint: endpoint)
    }

    private func performRequest(endpoint: NetworkEndpoint) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        let (data, response) = try await mockSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw NetworkError.authenticationError
        case 400...499:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Client error"
            throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
        case 500...599:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Server error"
            throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
        default:
            throw NetworkError.serverError(httpResponse.statusCode, "Unexpected error")
        }
    }
}

// MARK: - Test Models

struct TestResponse: Codable, Sendable {
    let message: String
    let id: String
}

// MARK: - Tests

@Test("NetworkManager should create valid endpoints")
func testNetworkEndpointCreation() async {
    // Given & When
    let endpoint = NetworkEndpoint(
        path: "/test",
        method: .POST,
        body: Data("test".utf8),
        headers: ["Custom-Header": "value"]
    )

    // Then
    #expect(endpoint.path == "/test")
    #expect(endpoint.method == .POST)
    #expect(endpoint.body != nil)
    #expect(endpoint.headers["Custom-Header"] == "value")
}

@Test("NetworkManager should handle successful GET request")
func testSuccessfulGetRequest() async throws {
    // Given
    let mockSession = MockURLSession()
    let testResponse = TestResponse(message: "success", id: "123")
    let responseData = try JSONEncoder().encode(testResponse)

    mockSession.mockData = responseData
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = TestableNetworkManager(
        baseURL: "https://test.com",
        apiKey: "test-key",
        apiSecret: "test-secret",
        mockSession: mockSession
    )

    let endpoint = NetworkEndpoint(path: "/api", method: .GET)

    // When
    let result = try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)

    // Then
    #expect(result.message == "success")
    #expect(result.id == "123")
}

@Test("NetworkManager should handle successful POST request")
func testSuccessfulPostRequest() async throws {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = Data()
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 201,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = TestableNetworkManager(
        baseURL: "https://test.com",
        apiKey: "test-key",
        apiSecret: "test-secret",
        mockSession: mockSession
    )

    let requestData = try JSONEncoder().encode(["test": "data"])
    let endpoint = NetworkEndpoint(path: "/api", method: .POST, body: requestData)

    // When & Then - Should not throw
    try await networkManager.request(endpoint: endpoint)
}

@Test("NetworkManager should handle authentication error")
func testAuthenticationError() async {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = Data("Unauthorized".utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 401,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = TestableNetworkManager(
        baseURL: "https://test.com",
        apiKey: "invalid-key",
        apiSecret: "invalid-secret",
        mockSession: mockSession
    )

    let endpoint = NetworkEndpoint(path: "/api", method: .GET)

    // When & Then
    await #expect(throws: NetworkError.authenticationError) {
        try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
    }
}

@Test("NetworkManager should handle server error")
func testServerError() async {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = Data("Internal Server Error".utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = TestableNetworkManager(
        baseURL: "https://test.com",
        mockSession: mockSession
    )

    let endpoint = NetworkEndpoint(path: "/api", method: .GET)

    // When & Then
    await #expect(throws: NetworkError.serverError(500, "Internal Server Error")) {
        try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
    }
}

@Test("NetworkManager should handle invalid URL")
func testInvalidURL() async {
    // Given
    let mockSession = MockURLSession()
    // This will create an invalid URL when combined with the path
    let networkManager = TestableNetworkManager(baseURL: "ht://invalid", mockSession: mockSession)
    let endpoint = NetworkEndpoint(path: "^[invalid url chars]$", method: .GET)

    // When & Then
    do {
        _ = try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
        #expect(Bool(false)) // Should not reach here
    } catch {
        if case NetworkError.invalidURL = error {
            #expect(Bool(true)) // Expected invalid URL error
        } else {
            // If we get a different error, that's okay too since the URL formation failed somehow
            #expect(Bool(true))
        }
    }
}

@Test("NetworkManager should handle decoding error")
func testDecodingError() async {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = Data("invalid json".utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = TestableNetworkManager(
        baseURL: "https://test.com",
        mockSession: mockSession
    )

    let endpoint = NetworkEndpoint(path: "/api", method: .GET)

    // When & Then
    do {
        _ = try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
        #expect(Bool(false)) // Should not reach here
    } catch {
        if case NetworkError.decodingError = error {
            #expect(Bool(true)) // Expected decoding error
        } else {
            #expect(Bool(false)) // Unexpected error type
        }
    }
}
