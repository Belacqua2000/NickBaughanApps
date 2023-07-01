//
//  ViewExtension.swift
//  Chronoderm
//
//  Created by Nick Baughan on 05/07/2022.
//

import SwiftUI

struct CustomFooterModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            #if os(macOS)
            .font(.footnote)
            .foregroundStyle(.secondary)
            #endif
    }
}

extension View {
    public func customFooter() -> some View {
        self.modifier(CustomFooterModifier())
    }
}
