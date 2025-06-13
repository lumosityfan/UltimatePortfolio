//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/27/25.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        var shouldRequestReview: Bool {
            if dataController.count(for: Tag.fetchRequest()) >= 5 {
                let reviewRequestCount = UserDefaults.standard.integer(forKey: "reviewRequestCount")
                UserDefaults.standard.set(reviewRequestCount + 1, forKey: "reviewRequestCount")
                
                if reviewRequestCount.isMultiple(of: 10) {
                    return true
                }
            }
            
            return false
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        func delete(_ offsets: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()
            
            for offset in offsets {
                let item = issues[offset]
                dataController.delete(item)
            }
        }
    }
}
