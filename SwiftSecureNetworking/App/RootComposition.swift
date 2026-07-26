//
//  RootComposition.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 23/07/2026.
//

import SwiftUI

struct RootComposition: View {
    
    private let container = DIContainer.shared
    
    @State private var coordinator = AppCoordinator()

    var body: some View {

        NavigationStack(path: $coordinator.path) {

            switch coordinator.flow {

            case .authentication:
                Text("Authentication Flow")

            case .main:
                VStack(spacing: 20) {

                    Text("Main Flow")

                    Button("Open Product") {
                        coordinator.showProduct(id: 10)
                    }

                }
            }

        }
        .navigationDestination(for: AppRoute.self) { route in

            switch route {

            case .product(let id):
                Text("Product \(id)")

            case .profile:
                Text("Profile")
            }
        }

    }

}
#Preview {
    RootComposition()
}

