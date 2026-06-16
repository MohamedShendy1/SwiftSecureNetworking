//
//  NetworkClientProtocol.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 14/05/2026.
//

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, _ type: T.Type) async throws -> T
}
