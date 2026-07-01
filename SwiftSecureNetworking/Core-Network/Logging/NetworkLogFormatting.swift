//
//  LogFormatter.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//

import Foundation

protocol NetworkLogFormattingProtocol {
    func format(
        level: LogLevel,
        entry: NetworkLogEntry
    ) -> String
}


final class DefaultNetworkLogFormatter: NetworkLogFormattingProtocol {
    private let separator = String(repeating: "═", count: 70)
    
    private let configuration: LogConfiguration

       init(configuration: LogConfiguration) {
           self.configuration = configuration
       }
    
    func format(
        level: LogLevel,
        entry: NetworkLogEntry
    ) -> String {

        [
            formatHeader(level, entry),
            formatRequest(entry),
            formatResponse(entry),
            formatError(entry),
            formatFooter(entry)
        ]
        .joined(separator: "\n")
    }

    // MARK: - Private Helpers

    // MARK: - Header
    private func formatHeader(
        _ level: LogLevel,
        _ entry: NetworkLogEntry
    ) -> String {

        """
        \(separator)

        🌐 NETWORK REQUEST

        Request ID : \(entry.requestID)

        Level      : \(level.title)

        Method     : \(entry.method.rawValue)

        URL        : \(entry.url.absoluteString)

        Started At : \(dateFormatter.string(from: entry.startedAt))

        \(separator)
        """

    }
    

    // MARK: - Request
    private func formatRequest(
        _ entry: NetworkLogEntry
    ) -> String {
        ""
    }

    // MARK: - Response
    private func formatResponse(
        _ entry: NetworkLogEntry
    ) -> String {
        ""
    }

    // MARK: - Error
    private func formatError(
        _ entry: NetworkLogEntry
    ) -> String {
        ""
    }

    // MARK: - Footer
    private func formatFooter(
        _ entry: NetworkLogEntry
    ) -> String {
        ""
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
}


