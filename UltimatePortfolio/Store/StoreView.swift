//
//  StoreView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 6/7/25.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @Environment(\.purchase) var purchaseAction
    
    enum LoadState {
        case loading, loaded, error
    }
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var loadState = LoadState.loading
    @State private var showingPurchaseError = false
    
    func checkForPurchase() {
        if dataController.fullVersionUnlocked {
            dismiss()
        }
    }
    
    func purchase(_ product: Product) {
        guard AppStore.canMakePayments else {
            showingPurchaseError.toggle()
            return
        }
        
        Task { @MainActor in
            let result = try await purchaseAction(product)
            
            if case let .success(validation) = result {
                try await dataController.finalize(validation.payloadValue)
            }
        }
    }
    
    func load() async {
        loadState = .loading
        
        do {
            try await dataController.loadProducts()
            
            if dataController.products.isEmpty {
                loadState = .error
            } else {
                loadState = .loaded
            }
        } catch {
            loadState = .error
        }
    }
    
    func restore() {
        Task {
            try await AppStore.sync()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // header
                VStack {
                    Image(decorative: "unlock")
                        .resizable()
                        .scaledToFit()
                    
                    Text("Upgrade Today!")
                        .font(.title.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Text("Get the most out of the app")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.blue.gradient)
                
                ScrollView {
                    VStack {
                        switch loadState {
                        case .loading:
                            Text("Fetching offers...")
                                .font(.title2.bold())
                                .padding(.top, 50)
                            ProgressView()
                                .controlSize(.large)
                            
                        case .loaded:
                            ForEach(dataController.products) { product in
                                Button {
                                    purchase(product)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(product.displayName)
                                                .font(.title2.bold())
                                            Text(product.description)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(product.displayPrice)
                                            .font(.title)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2), in: .rect(cornerRadius: 20))
                                    .contentShape(.rect)
                                }
                                .buttonStyle(.plain)
                            }
                            
                        case .error:
                            Text("Sorry, there was an error loading our store.")
                                .padding(.top, 50)
                            
                            Button("Try Again") {
                                Task {
                                    await load()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(20)
                }
                
                // footer
                Button("Restore Purchases", action: restore)
                
                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 20)
            }
        }
        .onChange(of: dataController.fullVersionUnlocked, checkForPurchase) 
        .task {
            await load()
        }
        .alert("In-app purchases are disabled", isPresented: $showingPurchaseError) {
        } message: {
            Text("""
                You can't purchase the premium unlock because in-app purchases are disabled on this device.
                
                Please ask whomever manages your device for assistance.
                """)
        }
    }
}

#Preview {
    StoreView()
        .environmentObject(DataController(inMemory: true))
}
