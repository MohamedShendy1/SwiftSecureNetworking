//
//  LogFormatter.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//

import Foundation


//Notice: -this protocol knows LogLevel & NetworkLogEntry and returns String

protocol NetworkLogFormattingProtocol {

    func format(
        level: LogLevel,
        entry: NetworkLogEntry
    ) -> String

}


final class DefaultNetworkLogFormatter: NetworkLogFormattingProtocol {

    func format(
        level: LogLevel,
        entry: NetworkLogEntry
    ) -> String {

        ""

    }

}
