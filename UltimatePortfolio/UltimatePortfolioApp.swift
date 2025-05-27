//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/12/25.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(dataController: dataController)
            } content: {
                ContentView(dataController: dataController)
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
            }
        }
    }
}
