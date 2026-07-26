//
//  LogConfiguration.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//

import Foundation

struct LogConfiguration {

    let minimumLevel: LogLevel

    let logHeaders: Bool

    let logRequestBody: Bool

    let logResponseBody: Bool

    let prettyPrintJSON: Bool

    let redactSensitiveData: Bool
}


extension LogConfiguration {

    static let debug = LogConfiguration(

        minimumLevel: .trace,

        logHeaders: true,

        logRequestBody: true,

        logResponseBody: true,

        prettyPrintJSON: true,

        redactSensitiveData: true
    )

    static let release = LogConfiguration(

        minimumLevel: .error,

        logHeaders: false,

        logRequestBody: false,

        logResponseBody: false,

        prettyPrintJSON: false,

        redactSensitiveData: true
    )

}
