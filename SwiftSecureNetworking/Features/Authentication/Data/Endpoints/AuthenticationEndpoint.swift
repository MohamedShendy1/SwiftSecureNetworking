//
//  AuthenticationEndpoint.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 05/08/2026.
//

import Foundation

enum AuthenticationEndpoint: Endpoint {
    var baseURL: URL {
           guard let url = URL(string: "https://your-api-domain.com") else {
               preconditionFailure("Invalid API base URL")
           }
           return url
       }
   

    case login(
        email: String,
        password: String
    )
    
    

    var path: String {

        switch self {

        case .login:
            return "/login"

        }
    }
    
    var method: HTTPMethod {

        switch self {

        case .login:
            return .POST

        }
    }
    
    
    var header: [String : String] {
        [:]
    }
    
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Encodable? {

        switch self {

        case let .login(email, password):
            return LoginRequestDTO(
                email: email,
                password: password
            )
        }
    }
    
    
}




