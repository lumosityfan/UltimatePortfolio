//
//  IssueRowViewModel.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 5/27/25.
//

import Foundation

extension IssueRow {
    class ViewModel: ObservableObject {
        let issue: Issue
        
        init(issue: Issue) {
            self.issue = issue
        }
        
        var iconOpacity: Double {
            issue.priority == 2 ? 1 : 0
        }
        
        var iconIdentifier: String {
            issue.priority == 2 ? "\(issue.issueTitle) High Priority" : ""
        }
        
        var accessibilityHint: String {
            issue.priority == 2 ? "High priority" : ""
        }
        
        var creationDate: String {
            issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        var accessibilityCreationDate: String {
            issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
