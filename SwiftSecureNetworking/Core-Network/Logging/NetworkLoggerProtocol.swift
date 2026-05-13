//
//  NetworkLoggerProtocol.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//

import Foundation

protocol NetworkLoggerProtocol {
    func log(_ request: URLRequest)
    func log(_ response: URLResponse, data: Data)
    func log(_ error: Error, for request: URLRequest)
}
