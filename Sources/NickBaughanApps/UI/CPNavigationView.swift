//
//  CPNavigationView.swift
//  Chronoderm
//
//  Created by Nick Baughan on 14/05/2022.
//

import SwiftUI

public struct CPNavigationView<Content: View>: View {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @ViewBuilder let content: Content
    public var body: some View {
        #if os(macOS)
        content
        #else
        NavigationStack {
            content
        }
        #endif
    }
}
