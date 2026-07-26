//
//  ConsoleLogDestination.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 29/06/2026.
//


import Foundation

final class ConsoleNetworkLogDestination: NetworkLogDestinationProtocol {

    func write(_ message: String) {
        print(message)
    }

}
