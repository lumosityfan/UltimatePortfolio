//
//  NumberBadge.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 6/13/25.
//

import SwiftUI

extension View {
    func numberBadge(_ number: Int) -> some View {
        #if os(watchOS)
        self
        #else
        self.badge(number)
        #endif
    }
}
