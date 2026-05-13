//
//  BodyEncodingStrategy.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//

import Foundation

protocol BodyEncodingStrategy {
    func encode( _ body: (any Encodable)?) throws -> Data?
}



