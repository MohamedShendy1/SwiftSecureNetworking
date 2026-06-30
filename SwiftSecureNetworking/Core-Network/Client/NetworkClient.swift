//
//  NetworkClient.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 14/05/2026.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    private let builder:  RequestBuilder
    private let session:  URLSession
//    private let retry:    RetryStrategy
    private let decoder:  JSONDecoder          // FIX 3 — injected, not inline
    private let logger:   NetworkLoggerProtocol

    init(
        builder:  RequestBuilder,
        session:  URLSession,
//        retry: RetryStrategy = DefaultRetryStrategy(),
        decoder:  JSONDecoder = {               // FIX 3
            let d = JSONDecoder()
            d.keyDecodingStrategy  = .convertFromSnakeCase
            d.dateDecodingStrategy = .iso8601
            return d
        }(),
        logger:   NetworkLoggerProtocol
    ) {
        self.builder = builder
        self.session = session
//        self.retry   = retry
        self.decoder = decoder
        self.logger  = logger
    }
    

    
    func request<T: Decodable & Sendable>(endpoint: Endpoint, type: T.Type, attempt: Int = 0) async throws -> T {
        let urlRequest = try builder.build(from: endpoint)
//        logger.log( urlRequest)

        let (data, response): (Data, URLResponse)

        // FIX 2 — URLError caught and mapped here, never escapes
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            let mapped = mapURLError(urlError)
//            logger.log(mapped, for: urlRequest)
            throw mapped
        }

//        logger.log(response, data: data)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(code: -1, data: data)
        }

        // Map HTTP status codes to typed errors
        let networkError = mapStatusCode(http.statusCode, data: data)

        
        //TODO: - Retry
        
//        if let networkError {
//            // FIX 4 — only retry transient, server-side failures with backoff
//            if retry.shouldRetry(networkError, attempt: attempt) {
//                let delay = retry.delay(for: attempt)
//                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
//                return try await request(endpoint, type: type, attempt: attempt + 1)
//            }
//            throw networkError
//        }

        // FIX 3 — decoder is pre-configured, not inline JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    
    // MARK: Private helpers

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet,
             .networkConnectionLost,
             .dataNotAllowed:
            return .noInternetConnection
        case .timedOut:
            return .timeout
        case .badURL, .unsupportedURL:
            return .invalidURL
        default:
            return .unknown(error)
        }
    }

    /// Returns nil for 2xx (success), a typed error for everything else.
    private func mapStatusCode(_ code: Int, data: Data?) -> NetworkError? {
        switch code {
        case 200...299: return nil
        case 401:       return .unauthorized
        case 403:       return .forbidden
        case 404:       return .notFound
        case 500...599: return .serverError(statusCode: code)
        default:        return .invalidResponse(code: code, data: data)
        }
    }
    
    
}
