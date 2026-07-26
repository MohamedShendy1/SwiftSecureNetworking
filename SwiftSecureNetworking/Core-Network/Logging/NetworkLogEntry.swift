//
//  NetworkLogEntry.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//


import Foundation

struct NetworkLogEntry {

    let requestID: UUID

    let method: HTTPMethod

    let url: URL

    let statusCode: Int?

    let requestHeaders: [String: String]

    let responseHeaders: [String: String]

    let requestBody: Data?

    let responseBody: Data?

    let responseSize: Int

    let mimeType: String?

    let duration: TimeInterval

    let error: NetworkError?

    let startedAt: Date

    let isSuccess: Bool
}
