//
//  NetworkClientProtocol.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 14/05/2026.
//

protocol NetworkClientProtocol {
    func request<T: Decodable & Sendable>(endpoint: Endpoint, type: T.Type, attempt: Int) async throws -> T
}
