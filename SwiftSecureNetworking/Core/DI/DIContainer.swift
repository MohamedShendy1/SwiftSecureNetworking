//
//  DIContainer.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//


import Foundation
import Security
import CryptoKit

final class DIContainer {

    static let shared = DIContainer(environment: .debug)

    private let environment: AppEnvironment
    

    private init(environment: AppEnvironment) {
        self.environment = environment
    }

    // ========================================================
    // MARK: URLSession (Pinned)
    // ========================================================

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60

        let delegate = PinningSessionDelegate(pinnedHashes: [
            "YOUR_CERT_SHA256_HEX_HASH_HERE",
            "YOUR_BACKUP_CERT_HASH_HERE"
        ])

        return URLSession(
            configuration: config,
            delegate: delegate,
            delegateQueue: nil
        )
    }()

    // ========================================================
    // MARK: Body Encoder
    // ========================================================

    private lazy var bodyEncoder: BodyEncodingStrategy = {
        JSONBodyEncoder()
    }()

    // ========================================================
    // MARK: Request Builder
    // ========================================================

    private lazy var requestBuilder: RequestBuilder = {
        RequestBuilder(
            bodyEncoder: bodyEncoder
//            tokenProvider: tokenProvider
        )
    }()

    // ========================================================
    // MARK: JSON Decoder (single source of truth)
    // ========================================================

    private lazy var decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    
    // ========================================================
    // MARK: Log Configuration
    // ========================================================
    private var logConfiguration: LogConfiguration {
        environment.logConfiguration
    }

    // ========================================================
    // MARK: Log Formatter
    // ========================================================
    private lazy var logFormatter: NetworkLogFormattingProtocol = {
        DefaultNetworkLogFormatter(
            configuration: logConfiguration
        )
    }()

    // ========================================================
    // MARK: Log Destination
    // ========================================================
    private lazy var logDestination: NetworkLogDestinationProtocol = {
        ConsoleNetworkLogDestination()
    }()

    // ========================================================
    // MARK: Logger
    // ========================================================

    private lazy var logger: NetworkLoggerProtocol = {

        NetworkLogger(
            configuration: logConfiguration,
            formatter: logFormatter,
            destination: logDestination
        )

    }()
    
    // ========================================================
    // MARK: Log Entry Factory
    // ========================================================

    private lazy var logEntryFactory: NetworkLogEntryFactoryProtocol = {
        DefaultNetworkLogEntryFactory()
    }()
    
    // ========================================================
    // MARK: NetworkClient
    // ========================================================

    private lazy var networkClient: NetworkClientProtocol = {
        NetworkClient(
            builder: requestBuilder,
            session: session,
            // retry: retryStrategy,

            decoder: decoder,
            logger: logger,
            logEntryFactory: logEntryFactory
        )
    }()

    // ========================================================
    // MARK: Public Factories
    // ========================================================

    func makeNetworkClient() -> NetworkClientProtocol {
        networkClient
    }
    
}





enum AppEnvironment {
    case debug
    case release

    var isLoggingEnabled: Bool {
        switch self {
        case .debug: return true
        case .release: return false
        }
    }
}

extension AppEnvironment {

    var logConfiguration: LogConfiguration {
        switch self {
        case .debug:
            return .debug

        case .release:
            return .release
        }
    }
}
