//
//  NetworkLoggerProtocol.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//

import Foundation

protocol NetworkLoggerProtocol {

    func log(
        level: LogLevel,
        entry: NetworkLogEntry
    )

}
