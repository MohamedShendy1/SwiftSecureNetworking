//
//  NetworkLogger.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//


import Foundation

final class NetworkLogger: NetworkLoggerProtocol {
 
    private let isEnabled: Bool

    init(isEnabled: Bool = true ) {
        self.isEnabled = isEnabled
    }
    
 
    func log(_ request: URLRequest) {
        guard isEnabled else { return }
        print("➡️  [\(request.httpMethod ?? "?")] \(request.url?.absoluteString ?? "")")
    }
    
    func log(_ response: URLResponse, data: Data) {
        guard isEnabled else { return }
        let code = (response as? HTTPURLResponse)?.statusCode ?? 0
        print("⬅️  [ HTTP\(code) - \(data.count) bytes] ")
    }
    
    func log(_ error: any Error, for request: URLRequest) {
        guard isEnabled else { return }
        print("❌  \(request.url?.absoluteString ?? ""): \(error.localizedDescription)")
    }
    
}



final class SilentLogger: NetworkLoggerProtocol {
    func log(_ request: URLRequest) {}
    func log(_ response: URLResponse, data: Data) {}
    func log(_ error: Error, for request: URLRequest) {}
}
