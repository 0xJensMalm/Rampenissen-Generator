//
//  PurchasePromptView.swift
//  Rampenissen
//
//  Created by Jens Aga Malm on 09/12/2023.
//

import SwiftUI

struct PurchasePromptView: View {
    @Binding var showPurchasePrompt: Bool
    @Binding var isProVersionPurchased: Bool

    var body: some View {
        VStack {
            // Content of your purchase prompt
            Text("Unlock Pro Version")
            Button("Unlock") {
                // Logic to unlock Pro Version
                isProVersionPurchased = true
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isProVersionPurchased)
                showPurchasePrompt = false
            }
            Button("Cancel") {
                showPurchasePrompt = false
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
