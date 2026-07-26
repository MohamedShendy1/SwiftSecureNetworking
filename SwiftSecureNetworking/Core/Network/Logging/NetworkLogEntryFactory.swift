//
//  NetworkLogEntryFactory.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 23/07/2026.
//

import Foundation


// ========================================================
// MARK: Protocol
// ========================================================

protocol NetworkLogEntryFactoryProtocol {

    func make(
        request: URLRequest,
        response: HTTPURLResponse?,
        responseData: Data?,
        error: NetworkError?,
        startedAt: Date,
        duration: TimeInterval
    ) -> NetworkLogEntry

}



// ========================================================
// MARK: Default Factory
// ========================================================

final class DefaultNetworkLogEntryFactory: NetworkLogEntryFactoryProtocol {


    func make(
        request: URLRequest,
        response: HTTPURLResponse?,
        responseData: Data?,
        error: NetworkError?,
        startedAt: Date,
        duration: TimeInterval
    ) -> NetworkLogEntry {

        let requestID = UUID()

        guard
            let rawMethod = request.httpMethod,
            let method = HTTPMethod(rawValue: rawMethod)
        else {
            preconditionFailure("Request contains an invalid HTTP method.")
        }
        
        let responseSize = responseData?.count ?? 0

        let mimeType = response?.mimeType

        let statusCode = response?.statusCode


        let requestHeaders =
        request.allHTTPHeaderFields ?? [:]


        let responseHeaders =
        response?.allHeaderFields.reduce(
            into: [String:String]()
        ) { result, item in

            result["\(item.key)"] = "\(item.value)"

        } ?? [:]


        let isSuccess =
        error == nil &&
        (statusCode.map { 200...299 ~= $0 } ?? false)



        return NetworkLogEntry(

            requestID: requestID,

            method: method,

            url: request.url ?? URL(string: "unknown://")!,

            statusCode: statusCode,


            requestHeaders: requestHeaders,

            responseHeaders: responseHeaders,


            requestBody: request.httpBody,

            responseBody: responseData,


            responseSize: responseSize,


            mimeType: mimeType,


            duration: duration,


            error: error,


            startedAt: startedAt,


            isSuccess: isSuccess
        )
    }

}
