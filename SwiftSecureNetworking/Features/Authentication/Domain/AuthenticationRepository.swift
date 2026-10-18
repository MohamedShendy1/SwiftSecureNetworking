//
//  Repository.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 26/07/2026.
//



protocol AuthenticationRepository {

    func login(
        email: String,
        password: String
    ) async throws -> AuthSession

}
