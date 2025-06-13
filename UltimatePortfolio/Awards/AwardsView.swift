//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/3/25.
//

import SwiftUI

struct AwardsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }
    
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "unlocked: \(award.name)" : "Locked"
    }
    
    var awardTitle: LocalizedStringKey {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(color(for: award))
                        }
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(award.description)
                        .buttonStyle(.borderless)
                    }
                }
            }
            .navigationTitle("Awards")
            #if !os(watchOS)
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            #endif
        }
        .alert(awardTitle, isPresented: $showingAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }
        .macFrame(minWidth: 600, maxHeight: 500)
    }
}

#Preview {
    AwardsView()
}
