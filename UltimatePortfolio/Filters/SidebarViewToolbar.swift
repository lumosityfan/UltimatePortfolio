//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/14/25.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State var showingAwards = false
    
    var body: some View {
#if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
#endif
        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
        }
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)    }
}

#Preview {
    SidebarViewToolbar()
}
