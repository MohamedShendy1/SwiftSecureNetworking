//
//  JSONBodyEncoder.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//

import Foundation

final class JSONBodyEncoder: BodyEncodingStrategy {
    
    private let encoder: JSONEncoder
    
    init(encoder: JSONEncoder = JSONEncoder()){
        self.encoder = encoder
    }
    
    func encode( _ body: (any Encodable)?) throws -> Data? {
        guard let body else { return nil}
        
        do{
            return try encoder.encode(body)
        }catch{
            throw NetworkError.encodingFailed(error)
        }
    }
}




