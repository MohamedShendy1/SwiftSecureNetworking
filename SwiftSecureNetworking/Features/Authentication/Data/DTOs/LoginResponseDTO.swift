//
//  LoginResponseDTO.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 05/08/2026.
//

import Foundation

struct LoginResponseDTO: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
}
