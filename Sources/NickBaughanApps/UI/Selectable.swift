//
//  Selectable.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 13/11/2024.
//

import SwiftUI

public struct Selectable: ViewModifier {
    
    public func body(content: Content) -> some View {
        #if os(tvOS)
        Button {} label: {
            content
        }
        .foregroundStyle(.primary)
        .accessibilityRemoveTraits(.isButton)
        #else
        content
        #endif
    }
}

public extension View {
    func selectable() -> some View {
        modifier(Selectable())
    }
}

#Preview {
    Text("Hello, World!")
        .selectable()
}
