//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 4/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    #if !os(watchOS)
    @Environment(\.requestReview) var requestReview
    #endif

    func askForReview() {
        #if !os(watchOS)
        if viewModel.shouldRequestReview {
            requestReview()
        }
        #endif
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func openURL(_ url: URL) {
        if url.absoluteString.contains("newIssue") {
            viewModel.dataController.newIssue()
        }
    }
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedIssue) {
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                #if os(watchOS)
                IssueRowWatch(issue: issue)
                #else
                IssueRow(issue: issue)
                #endif
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Issues")
        #if !os(watchOS)
        .searchable(
            text: $viewModel.dataController.filterText,
            tokens: $viewModel.dataController.filterTokens,
            suggestedTokens: .constant(viewModel.dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") { tag in
            Text(tag.tagName)
        }
        #endif
        .toolbar(content: ContentViewToolbar.init)
        .onAppear(perform: askForReview)
        .onOpenURL(perform: openURL)
        .macFrame(minWidth: 200)
    }
}

#Preview {
    ContentView(dataController: .preview)
}
