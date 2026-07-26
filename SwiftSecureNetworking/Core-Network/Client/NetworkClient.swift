//
//  NetworkClient.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 14/05/2026.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    private let builder:  RequestBuilderProtocol
    private let session:  URLSession
//    private let retry:    RetryStrategy
    private let decoder:  JSONDecoder          // FIX 3 — injected, not inline
    private let logger:   NetworkLoggerProtocol
    private let logEntryFactory: NetworkLogEntryFactoryProtocol
    
    init(
        builder:  RequestBuilderProtocol,
        session:  URLSession,
//        retry: RetryStrategy = DefaultRetryStrategy(),
        decoder:  JSONDecoder = {               // FIX 3
            let d = JSONDecoder()
            d.keyDecodingStrategy  = .convertFromSnakeCase
            d.dateDecodingStrategy = .iso8601
            return d
        }(),
        logger:   NetworkLoggerProtocol,
        logEntryFactory: NetworkLogEntryFactoryProtocol
    ) {
        self.builder = builder
        self.session = session
//        self.retry   = retry
        self.decoder = decoder
        self.logger  = logger
        self.logEntryFactory =  logEntryFactory
    }
    

    
    func request<T: Decodable & Sendable>(endpoint: Endpoint, type: T.Type, attempt: Int = 0) async throws -> T {
       
        let urlRequest = try builder.build(from: endpoint)
       //To get teh start time for the request - > (For the request log )
        let startedAt = Date()

        let (data, response): (Data, URLResponse)
        
       
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            
            let mapped = mapURLError(urlError)

            let duration = Date().timeIntervalSince(startedAt)

            log(
                level: .error,
                request: urlRequest,
                response: nil,
                responseData: nil,
                error: mapped,
                startedAt: startedAt,
                duration: duration
            )

            throw mapped
        }
        
        

// NOTE: -  Calculate the Request duration time -> (For the request log )
//        here because  We want the logger to measure network latency only.
        
        let duration = Date().timeIntervalSince(startedAt)
        

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(code: -1, data: data)
        }

        // Map HTTP status codes to typed errors
        let networkError = mapStatusCode(http.statusCode, data: data)
        
        if let networkError {
            log(
                level: .error,
                request: urlRequest,
                response: http,
                responseData: data,
                error: networkError,
                startedAt: startedAt,
                duration: duration
            )

            throw networkError
        }
   
        
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


        do {

            let model = try decoder.decode(T.self, from: data)

            log(
                level: .info,
                request: urlRequest,
                response: http,
                responseData: data,
                error: nil,
                startedAt: startedAt,
                duration: duration
            )

            return model
            
        } catch {
            
            let decodingError = NetworkError.decodingFailed(error)

            log(
                level: .error,
                request: urlRequest,
                response: http,
                responseData: data,
                error: decodingError,
                startedAt: startedAt,
                duration: duration
            )

            throw decodingError
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
    
    
    
    // ========================================================
    // MARK: -  Log Entry
    // ========================================================

    private func log(
        level: LogLevel,
        request: URLRequest,
        response: HTTPURLResponse?,
        responseData: Data?,
        error: NetworkError?,
        startedAt: Date,
        duration: TimeInterval
    ) {

        let entry = logEntryFactory.make(
            request: request,
            response: response,
            responseData: responseData,
            error: error,
            startedAt: startedAt,
            duration: duration
        )

        logger.log(
            level: level,
            entry: entry
        )
    }
    
}
