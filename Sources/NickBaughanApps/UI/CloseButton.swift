//
//  CloseButton.swift
//  Chronoderm
//
//  Created by Nick Baughan on 04/09/2022.
//

import SwiftUI

public struct CloseButton: ToolbarContent {
    public init() { }
    public init(title: String) {
        self.title = title
    }
    
    @Environment(\.dismiss) private var dismiss
    var title: String = String(localized: "Done", bundle: .module, comment: "The title of the close button.")
    var placement: ToolbarItemPlacement {
#if os(macOS) || os(watchOS)
        .cancellationAction
        #else
        .confirmationAction
#endif
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: dismiss.callAsFunction) {
                Label(title, systemImage: "xmark")
                    .symbolRenderingMode(.hierarchical)
            }
            .help(Text("Dismiss the current view", bundle: .module, comment: "The help descriptor for the close button."))
#if !os(watchOS)
            .keyboardShortcut(.cancelAction)
            .imageScale(.large)
#endif
            #if os(iOS) || os(macOS)
            .symbolVariant(.fill.circle)
            #endif
            
#if os(iOS)
            .font(.title2)
            .contentShape(.hoverEffect, Circle())
            .hoverEffect(.lift)
            .tint(.gray)
#elseif os(watchOS)
            .labelStyle(.iconOnly)
#elseif os(macOS)
            .labelStyle(.titleOnly)
#endif
        }
    }
}

/*struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}*/
