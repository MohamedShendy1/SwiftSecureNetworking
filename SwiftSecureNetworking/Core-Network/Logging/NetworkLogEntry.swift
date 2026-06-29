//
//  NetworkLogEntry.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//


import Foundation

struct NetworkLogEntry {

    let id: UUID

    let method: String

    let url: URL

    let statusCode: Int?

    let requestHeaders: [String:String]

    let responseHeaders: [AnyHashable:Any]

    let requestBody: Data?

    let responseBody: Data?

    let duration: TimeInterval

    let error: Error?

    let date: Date
}
