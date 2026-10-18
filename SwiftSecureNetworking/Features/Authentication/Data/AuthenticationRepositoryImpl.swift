//
//  Repository.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 26/07/2026.
//

import Foundation

class AuthenticationRepositoryImpl: AuthenticationRepository {

    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    func login(email: String, password: String) async throws -> AuthSession {
        
        
        let endpoint = AuthenticationEndpoint.login(
            email: email,
            password: password
        )
        
        
        let dto = try await networkClient.request(endpoint: endpoint, type: LoginResponseDTO.self, attempt: 0)
        
        // Map DTO to domain model. If your backend returns an expiration, replace the placeholder below.
        let session = AuthSession(
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            expirationDate: Date().addingTimeInterval(60 * 60) // TODO: replace with real expiration
        )
        
        return session
      
    }
    
    
    
    
}

