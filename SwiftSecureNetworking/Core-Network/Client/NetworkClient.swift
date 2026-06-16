//
//  NetworkClient.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 14/05/2026.
//

import Foundation

class NetworkClient: NetworkClientProtocol {
    
//    let builder: RequestBuilderProtocol
//    let session: URLSession
//    let decoder: JSONDecoder
//    let logger: NetworkLoggerProtocol
//    
//    // TODO: - Retry Strategy
//    
//    
//    init(builder: RequestBuilderProtocol = RequestBuilder(bodyEncoder: <#any BodyEncodingStrategy#>),
//         session: URLSession,
//         decoder: JSONDecoder = {
//        let d = JSONDecoder()
//        d.keyDecodingStrategy = .convertFromSnakeCase
//        d.dateDecodingStrategy = .iso8601
//        return d
//    }(),
//         logger: NetworkLoggerProtocol = NetworkLogger()
//    ) {
//        self.builder = builder
//        self.session = session
//        self.decoder = decoder
//        self.logger  = logger
//    }
    
    
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
        logger:   NetworkLoggerProtocol = NetworkLogger()
    ) {
        self.builder = builder
        self.session = session
//        self.retry   = retry
        self.decoder = decoder
        self.logger  = logger
    }
    
//    func request<T>(_ endpoint: any Endpoint, _ type: T.Type) async throws ->  T  {
//        
//    }
    
    
}
