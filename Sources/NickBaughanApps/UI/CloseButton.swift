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
                #if os(iOS)
                Image(systemName: "xmark")
                    .accessibilityLabel("Close")
                #else
                Label("Close", systemName: "xmark")
                #endif
            }
            .help(Text("Dismiss the current view", bundle: .module, comment: "The help descriptor for the close button."))
            #if !os(watchOS) && !os(tvOS)
            .keyboardShortcut(.cancelAction)
            .imageScale(.large)
            #endif
        
            #if os(iOS)
            .symbolVariant(.fill.circle)
            .font(.title2)
            .contentShape(.hoverEffect, .circle)
            .hoverEffect(.lift)
            .tint(.gray)
            .symbolRenderingMode(.hierarchical)
            #elseif os(watchOS)
            .labelStyle(.iconOnly)
            #elseif os(macOS)
            .labelStyle(.titleOnly)
            #endif
        }
    }
}

#Preview {
    Text("Hello, world!")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                Text("Hello, world!")
                    .toolbar(content: CloseButton.init)
            }
        }
}
