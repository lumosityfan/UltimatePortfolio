//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/14/25.
//

import Foundation

struct Filter: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var activeIssuesCount: Int {
        tag?.tagActiveIssues.count ?? 0
    }
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?
    
    static var all = Filter(
        id: UUID(),
        name: "All Issues",
        icon: "tray"
    )
    
    static var recent = Filter(
        id: UUID(),
        name: "Recent Issues",
        icon: "clock",
        minModificationDate: .now.addingTimeInterval(86400 * -7)
    )
}
