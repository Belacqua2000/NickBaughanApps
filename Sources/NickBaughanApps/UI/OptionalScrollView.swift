//
//  OptionalScrollView.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 20/07/2025.
//

import SwiftUI

struct OptionalScrollView<Content: View>: View {
    
    @ViewBuilder
    let content: Content
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            content
            ScrollView {
                content
            }
        }
    }
}
