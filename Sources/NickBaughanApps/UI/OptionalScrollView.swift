//
//  OptionalScrollView.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 20/07/2025.
//

import SwiftUI

public struct OptionalScrollView<Content: View>: View {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @ViewBuilder
    let content: Content
    
    public var body: some View {
        ViewThatFits(in: .vertical) {
            content
            ScrollView {
                content
            }
        }
    }
}
