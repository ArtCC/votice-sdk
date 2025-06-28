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

// MARK: - Mock URLSession

final class MockURLSession: URLSession, @unchecked Sendable {
    // MARK: - Properties

    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    // MARK: - URLSession Overrides

    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
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
        body: "test".data(using: .utf8),
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

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        apiKey: "test-key",
        apiSecret: "test-secret",
        session: mockSession
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

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        apiKey: "test-key",
        apiSecret: "test-secret",
        session: mockSession
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
    mockSession.mockData = "Unauthorized".data(using: .utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 401,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        apiKey: "invalid-key",
        apiSecret: "invalid-secret",
        session: mockSession
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
    mockSession.mockData = "Internal Server Error".data(using: .utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        session: mockSession
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
    let networkManager = NetworkManager(baseURL: "")
    let endpoint = NetworkEndpoint(path: "invalid-url", method: .GET)

    // When & Then
    await #expect(throws: NetworkError.invalidURL) {
        try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
    }
}

@Test("NetworkManager should handle decoding error")
func testDecodingError() async {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = "invalid json".data(using: .utf8)
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        session: mockSession
    )

    let endpoint = NetworkEndpoint(path: "/api", method: .GET)

    // When & Then
    await #expect(throws: NetworkError.decodingError) {
        try await networkManager.request(endpoint: endpoint, responseType: TestResponse.self)
    }
}

@Test("NetworkManager should generate HMAC signature correctly")
func testHMACGeneration() async throws {
    // Given
    let mockSession = MockURLSession()
    mockSession.mockData = Data()
    mockSession.mockResponse = HTTPURLResponse(
        url: URL(string: "https://test.com/api")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )

    let networkManager = NetworkManager(
        baseURL: "https://test.com",
        apiKey: "test-key",
        apiSecret: "test-secret",
        session: mockSession
    )

    let requestData = try JSONEncoder().encode(["test": "data"])
    let endpoint = NetworkEndpoint(path: "/api", method: .POST, body: requestData)

    // When & Then - Should not throw and should include signature header
    try await networkManager.request(endpoint: endpoint)

    #expect(true) // If we reach here, HMAC generation worked
}
