//
//  InlineNavigationBar.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 6/12/25.
//

import SwiftUI

extension View {
    func inlineNavigationBar() -> some View {
        #if os(macOS)
        self
        #else
        self.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
