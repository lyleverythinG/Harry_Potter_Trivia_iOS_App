//
//  Store.swift
//  Harry_Potter_Trivia_iOS_App
//
//  Created by Lyle Dane Carcedo on 12/20/24.
//

import Foundation
import StoreKit

enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldnt fetch products: \(error)")
        }
    }
}
