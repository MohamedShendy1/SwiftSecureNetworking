//
//  Eedpoint.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var body: Encodable? { get }
    var queryItems: [URLQueryItem]? { get }
    var requiresAuth: Bool { get }
}


extension Endpoint {
    
    var heade: [String: String] {["contentType": "Aplication/ json", "Accept": "Aplication/json" ]}
    var body: Encodable? {nil}
    var queryItems: [URLQueryItem]? {nil}
    var requiresAuth: Bool {true}
    
}
