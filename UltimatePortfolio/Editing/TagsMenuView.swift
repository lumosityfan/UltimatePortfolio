//
//  TagsMenuView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/15/25.
//

import SwiftUI

struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var issue: Issue
    
    var body: some View {
        #if !os(watchOS)
        // show selected tags first
        ForEach(issue.issueTags) { tag in
            Button {
                issue.removeFromTags(tag)
            } label: {
                Label(tag.tagName, systemImage: "checkmark")
            }
        }
        
        // now show unselected tags
        let otherTags = dataController.missingTags(from: issue)
        
        if otherTags.isEmpty == false {
            Divider()
            
            Section("Add Tags") {
                ForEach(otherTags) { tag in Button(tag.tagName) {
                    issue.addToTags(tag)
                    }
                }
            }
        }
        #endif
    }
}

#Preview {
    TagsMenuView(issue: .example)
        .environmentObject(DataController(inMemory: true))
}
