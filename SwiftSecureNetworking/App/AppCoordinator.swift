//
//  AppCoordinator.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 23/07/2026.
//

import SwiftUI

@Observable
final class AppCoordinator {
    
    var flow: AppFlow = .main
    
    var path = NavigationPath()
    
    func showAuthenticationFlow() {
        flow = .authentication
    }

    func showMainFlow() {
        flow = .main
    }
    
    func showProduct(id: Int) {
        path.append(
            AppRoute.product(id: id)
        )
    }

}
