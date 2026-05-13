//
//  NetworkError.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//
import Foundation

enum NetworkError: Error,LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case unauthorized                         // 401
    case forbidden                            // 403
    case notFound                             // 404
    case invalidResponse(code: Int, data: Data?)
    case serverError(statusCode: Int)         // 5xx
    case decodingFailed(Error)
    case encodingFailed(Error)
    case unknown(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:                        return "The request URL is malformed."
        case .noInternetConnection:              return "No internet connection."
        case .timeout:                           return "The request timed out."
        case .unauthorized:                      return "Authentication required."
        case .forbidden:                         return "You don't have permission."
        case .notFound:                          return "Resource not found."
        case .invalidResponse(let code ,_):      return "Invalid response (HTTP \(code))."
        case .serverError(let c):                return "Server error (HTTP \(c))."
        case .decodingFailed(let e):             return "Could not parse response: \(e.localizedDescription)"
        case .encodingFailed(let e):             return "Could not encode request: \(e.localizedDescription)"
        case .unknown(let e):                    return e.localizedDescription
            
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .timeout, .notFound: return true
        case .serverError(let code):  return code >= 500
        case .invalidResponse(let code , _):  return code >= 500
        default: return false
        }
    }

    
}
