//
//  BCToolbarLabelStyle.swift
//  Hills
//
//  Created by Nick Baughan on 18/09/2025.
//

import SwiftUI

public struct BCToolbarLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Label { configuration.title } icon: { configuration.icon }
            #if os(macOS)
                .labelStyle(.titleOnly)
            #endif
        } else {
            configuration.title
        }
    }
}

public extension LabelStyle where Self == BCToolbarLabelStyle {
    static var bcToolbar: Self {
        BCToolbarLabelStyle()
    }
}
