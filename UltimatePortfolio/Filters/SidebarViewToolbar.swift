//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/14/25.
//

import SwiftUI

struct SidebarViewToolbar: ToolbarContent {
    @EnvironmentObject var dataController: DataController
    @State private var showingStore = false
    @State var showingAwards = false
    
    func tryNewTag() {
        if dataController.newTag() == false {
            showingStore = true
        }
    }
    
    var body: some ToolbarContent {
#if DEBUG
        ToolbarItem(placement: .automatic) {
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
        }
#endif
        ToolbarItem(placement: .automaticOrTrailing) {
            Button(action: tryNewTag) {
                Label("Add tag", systemImage: "plus")
            }
            .sheet(isPresented: $showingStore, content: StoreView.init)
            .help("Add tag")
        }
        
        ToolbarItem(placement: .automaticOrLeading) {
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }
            .sheet(isPresented: $showingAwards, content: AwardsView.init)
            .help("Show awards")
        }
    }
}
