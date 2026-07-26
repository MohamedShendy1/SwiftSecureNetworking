//
//  NetworkLogger.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 13/05/2026.
//


import Foundation

final class NetworkLogger: NetworkLoggerProtocol {
 
    private let configuration: LogConfiguration
    private let formatter: NetworkLogFormattingProtocol
    private let destination: NetworkLogDestinationProtocol
   
    init(
        configuration: LogConfiguration,
        formatter: NetworkLogFormattingProtocol,
        destination: NetworkLogDestinationProtocol
    ) {

        self.configuration = configuration
        self.formatter     = formatter
        self.destination   = destination

    }
    
   
    func log(level: LogLevel, entry: NetworkLogEntry) {
        
        guard shouldLog(level: level) else {
            return
        }

        let message = formatter.format(
            level: level,
            entry: entry
        )
        
        destination.write(message)
    }
    
    
    private func shouldLog(level: LogLevel) -> Bool {
        level >= configuration.minimumLevel
    }
   
    

    
}
