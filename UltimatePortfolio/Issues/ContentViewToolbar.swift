//
//  ContentViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/15/25.
//

import SwiftUI

struct ContentViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        #if !os(watchOS)
        Menu {
            Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                dataController.filterEnabled.toggle()
            }
            
            Divider()
            
            Menu("Sort By") {
                Picker("Sort By", selection: $dataController.sortType) {
                    Text("Date Created").tag(SortType.dateCreated)
                    Text("Date Modified").tag(SortType.dateModified)
                }
                .pickerStyle(.inline)
                .labelsHidden()
                
                Divider()
                
                Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            
            Picker("Status", selection: $dataController.filterStatus) {
                Text("All").tag(Status.all)
                Text("Open").tag(Status.open)
                Text("Closed").tag(Status.closed)
            }
            .disabled(dataController.filterEnabled == false)
            
            Picker("Priority", selection: $dataController.filterPriority) {
                Text("All").tag(-1)
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .disabled(dataController.filterEnabled == false)
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataController.filterEnabled ? .fill : .none)
        }
        .help("Filter")
        
        Button(action: dataController.newIssue) {
            Label("New Issue", systemImage: "square.and.pencil")
        }
        .help("New Issue")
        #endif
    }
}

#Preview {
    ContentViewToolbar()
        .environmentObject(DataController(inMemory: true))
}
