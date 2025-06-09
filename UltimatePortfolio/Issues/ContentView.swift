//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.requestReview) var requestReview

    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedIssue) {
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Issues")
        .searchable(
            text: $viewModel.dataController.filterText,
            tokens: $viewModel.dataController.filterTokens,
            suggestedTokens: .constant(viewModel.dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") { tag in
            Text(tag.tagName)
        }
        .toolbar(content: ContentViewToolbar.init)
        .onAppear(perform: askForReview)
    }
}

#Preview {
    ContentView(dataController: .preview)
}
