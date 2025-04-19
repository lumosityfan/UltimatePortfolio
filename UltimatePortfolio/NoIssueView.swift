//
//  NoIssueView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/18/25.
//

import SwiftUI

struct NoIssueView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Text("No Issue Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Issue") {
            // make a new issue
        }
    }
}

#Preview {
    NoIssueView()
}
