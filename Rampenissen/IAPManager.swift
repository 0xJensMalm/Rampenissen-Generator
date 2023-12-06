//
//  IAPManager.swift
//  Rampenissen
//
//  Created by Jens Aga Malm on 08/12/2023.
//

import Foundation
import StoreKit



class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // code
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //code
    }
    
    static let shared = IAPManager()
    // Product Identifiers
    let PRO_VERSION_PRODUCT_ID = "com.yourapp.proversion"
    
    // Other IAP properties and methods...
    // - fetchProducts()
    // - purchase(product:)
    // - restorePurchases()
    // - etc.
}
