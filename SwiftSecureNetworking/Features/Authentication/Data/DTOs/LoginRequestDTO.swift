//
//  LoginRequestDTO.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 05/08/2026.
//

import Foundation

struct LoginRequestDTO: Encodable {
    
    let email: String
    
    let password: String
}
