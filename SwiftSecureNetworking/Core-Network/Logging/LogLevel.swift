//
//  LogLevel.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//



// NOTE:- Now production can ignore (trace & debug) while keeping (error & critical)

import Foundation

enum LogLevel: Int {

    case trace = 0

    case debug

    case info

    case warning

    case error

    case critical
}

extension LogLevel: Comparable {

    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

}
