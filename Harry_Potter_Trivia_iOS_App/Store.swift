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
    @Published var purchasedIDs = Set<String>()
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private var productToBookMap: [String: Int] {
        [
            "hp4": 3,
            "hp5": 4,
            "hp6": 5,
            "hp7": 6
        ]
    }
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldnt fetch products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
                // Purchase successful, but need to verify receipt.
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                    
                    if let bookIndex = productToBookMap[signedType.productID] {
                        books[bookIndex] = .active
                    }
                }
                
                // User cancelled or parent disapproved child's purchase request.
            case .userCancelled:
                break
                
                // Waiting for approval.
            case .pending:
                break
                
            @unknown default:
                break
            }
        } catch {
            print("Couldnt purchase product: \(error)")
        }
    }
    
    private func checkPurchased() async {
        for product in products  {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                    
                    if let bookIndex = productToBookMap[signedType.productID] {
                        books[bookIndex] = .active
                    }
                } else {
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
