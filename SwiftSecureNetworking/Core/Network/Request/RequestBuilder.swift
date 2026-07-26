//
//  RequestBuilder.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//


import Foundation

// ============================================================
// MARK: RequestBuilder
// ============================================================

protocol RequestBuilderProtocol {
    
    func build(from endpoint: Endpoint) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {
   
    let bodyEncoder: BodyEncodingStrategy
    
    init(bodyEncoder: BodyEncodingStrategy) {
        self.bodyEncoder = bodyEncoder
    }
    
    
    func build(from endpoint: any Endpoint) throws -> URLRequest {
        
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)!
       
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        
        var heade = endpoint.header
        
        if endpoint.requiresAuth {
            //TODO: - throws immediately if no token
        }
        
        heade.forEach {request.setValue($1, forHTTPHeaderField: $0)}
        
        request.httpBody = try bodyEncoder.encode(endpoint.body)
        
        return request
    }
    
    
}

