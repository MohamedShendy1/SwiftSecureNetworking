//
//  UseCases.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 26/07/2026.
//


protocol AuthenticationUseCase {
    func execute(
        email: String,
        password: String
    ) async throws -> AuthSession
}

final class LoginUseCase: AuthenticationUseCase {

    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository){
        
        self.repository = repository
    }
    
    func execute(
        email: String,
        password: String
    ) async throws -> AuthSession {
       try await repository.login(email: email, password: password)
    }
    
}


