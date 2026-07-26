//
//  LogFormatter.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//

import Foundation


// ========================================================
// MARK: protocol
// ========================================================

protocol NetworkLogFormattingProtocol {
    func format(level: LogLevel, entry: NetworkLogEntry) -> String
}



final class DefaultNetworkLogFormatter: NetworkLogFormattingProtocol {
   
    private let separator = String(repeating: "═", count: 70)
    
    private let configuration: LogConfiguration

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    // ========================================================
    // MARK: Init
    // ========================================================
    
    init(configuration: LogConfiguration) {
        self.configuration = configuration
    }
    
    // ========================================================
    // MARK: Public
    // ========================================================

    func format(level: LogLevel, entry: NetworkLogEntry) -> String {

        [
            formatHeader(level, entry),
            formatRequest(entry),
            formatResponse(entry),
            formatError(entry),
            formatFooter(entry)
        ]
        .joined(separator: "\n")
    }
    
}


// ========================================================
// MARK: - Header
// ========================================================

extension DefaultNetworkLogFormatter {

    private func formatHeader(_ level: LogLevel, _ entry: NetworkLogEntry) -> String {

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
}


// ========================================================
// MARK: - Request
// ========================================================

extension DefaultNetworkLogFormatter {

    private func formatRequest(_ entry: NetworkLogEntry) -> String {

        [
            requestTitle,
            requestHeaders(entry),
            requestBody(entry)
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n\n")
    }

    // MARK: - Title
    private var requestTitle: String {
        "📤 REQUEST"
    }

    // MARK: - Headers
    private func requestHeaders(_ entry: NetworkLogEntry) -> String {

        guard configuration.logHeaders else {
            return ""
        }

        guard !entry.requestHeaders.isEmpty else {
            return "Headers: None"
        }

        return """
        Headers

        \(entry.requestHeaders)
        """
    }
    
    
    private func formatHeaders(
        _ headers: [String:String]
    ) -> String {

        var lines: [String] = []

        for (key, value) in headers.sorted(by: { $0.key < $1.key }) {

            lines.append("\(key): \(value)")

        }

        return lines.joined(separator: "\n")

    }
    
    
    // MARK: - Body
    private func requestBody(_ entry: NetworkLogEntry) -> String {

        guard configuration.logRequestBody else {
            return ""
        }

        guard let body = entry.requestBody else {
            return "Body: None"
        }

        return """
        Body

        \(body.count) bytes
        """
    }

}

// ========================================================
// MARK: - Response
// ========================================================

extension DefaultNetworkLogFormatter {
    
    private func formatResponse( _ entry: NetworkLogEntry) -> String {

        [
            responseTitle,
            responseStatus(entry),
            responseDuration(entry),
            responseSize(entry),
            responseMimeType(entry)
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n\n")

    }
    
    // MARK: - Title
    private var responseTitle: String {
        "📥 RESPONSE"
    }
    
    // MARK: - Status
    private func responseStatus( _ entry: NetworkLogEntry ) -> String {
        
        guard let status = entry.statusCode else {
            return "Status : Unknown"
        }

        return "Status : \(status)"
    }
    
    // MARK: - Duration
    private func responseDuration(_ entry: NetworkLogEntry ) -> String {
        "Duration : \(formatDuration(entry.duration))"
    }
    
    
    // MARK: - ResponseSize
    private func responseSize(
        _ entry: NetworkLogEntry
    ) -> String {

        "Size : \(entry.responseSize) bytes"

    }
    
    
    // MARK: - ResponseMimeType
    private func responseMimeType(
        _ entry: NetworkLogEntry
    ) -> String {

        guard let mime = entry.mimeType else {
            return ""
        }

        return "MIME Type : \(mime)"

    }
    
    // MARK: - Helper
    private func formatDuration(_ duration: TimeInterval) -> String {

        if duration < 1 {
            let milliseconds = Int(duration * 1000)
            return "\(milliseconds) ms"
        }

        return String(format: "%.2f s", duration)
    }

}



// ========================================================
// MARK: - Error
// ========================================================

extension DefaultNetworkLogFormatter {
    
    private func formatError(
        _ entry: NetworkLogEntry
    ) -> String {
        
        guard entry.error != nil else {
            return ""
        }
        
        return [
            errorTitle,
            errorType(entry),
            errorDescription(entry)
        ]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
    
    
    private var errorTitle: String {
        "❌ Error"
    }
    
    
    private func errorType (_ entry: NetworkLogEntry) -> String {
        
        guard let error  = entry.error else {
            return ""
        }
        return "Type: \(type(of: error))"
        
    }
    
    
    private func errorDescription(_ entry: NetworkLogEntry ) -> String{
        guard let error = entry.error else {
            return ""
        }
        
        return "Description : \(error.localizedDescription)"
    }
    
    
    
}


// ========================================================
// MARK: - Footer
// ========================================================

extension DefaultNetworkLogFormatter {

    private func formatFooter(
        _ entry: NetworkLogEntry
    ) -> String {
        ""
    }
}

/**
Header
    headerTitle()
    headerMethod()
    headerURL()
    headerDate()

Request
    requestTitle()
    requestHeaders()
    requestBody()

Response
    responseTitle()
    responseStatus()
    responseDuration()
    responseSize()
    responseMimeType()

Error
    errorTitle()
    errorType()
    errorDescription()

Footer
    footerSeparator()
**/
