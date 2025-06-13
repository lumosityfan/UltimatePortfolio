//
//  DataController-Testing.swift
//  UltimatePortfolio
//
//  Created by Jeff Xie on 6/13/25.
//

import SwiftUI

extension DataController {
    func checkForTestEnvironment() {
        #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
        #endif
    }
}
