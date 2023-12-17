//
//  CloseButton.swift
//  Chronoderm
//
//  Created by Nick Baughan on 04/09/2022.
//

import SwiftUI

public struct CloseButton: ToolbarContent {
    public init() { }
    public init(title: LocalizedStringKey = "Done") {
        self.title = title
    }
    
    @Environment(\.dismiss) private var dismiss
    var title: LocalizedStringKey = "Done"
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
                Label(title, systemImage: "xmark.circle.fill")
#if !os(macOS)
                    .foregroundStyle(.gray)
#endif
                    .symbolRenderingMode(.hierarchical)
                    .imageScale(.large)
            }
            .help(Text("Dismiss the current view", comment: "Dismiss button help string"))
#if !os(watchOS)
            .keyboardShortcut(.cancelAction)
#endif
            
#if os(iOS)
            .font(.title2)
            .contentShape(.hoverEffect, Circle())
            .hoverEffect(.lift)
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
