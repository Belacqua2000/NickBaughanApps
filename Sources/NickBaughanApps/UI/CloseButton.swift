//
//  CloseButton.swift
//  Chronoderm
//
//  Created by Nick Baughan on 04/09/2022.
//

import SwiftUI

public struct CloseButton: ToolbarContent {
    public init() { }
    
    public init(title: String? = nil, toolbarPlacement: ToolbarItemPlacement? = nil) {
        if let title {
            self.title = title
        }
        
        if let toolbarPlacement {
            self.placement = toolbarPlacement
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var title: String = String(localized: "Done", bundle: .module, comment: "The title of the close button.")
    
    var placement: ToolbarItemPlacement = {
        #if os(watchOS)
        .cancellationAction
        #else
        .confirmationAction
        #endif
    }()
    
    let symbolVariant: SymbolVariants = {
        if #available(iOS 26, *) {
            .none
        } else {
            .fill.circle
        }
    }()
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: dismiss.callAsFunction) {
                #if os(iOS)
                Image(systemName: "xmark")
                    .accessibilityLabel(title)
                #else
                Label(title, systemImage: "xmark")
                #endif
            }
            .help(Text("Dismiss the current view", bundle: .module, comment: "The help descriptor for the close button."))
            #if os(iOS) || os(visionOS)
            .keyboardShortcut(.cancelAction)
            .imageScale(.large)
            #endif
        
            #if os(iOS)
            .symbolVariant(symbolVariant)
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
    Color.blue
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                Color.pink
                    .toolbar(content: CloseButton.init)
            }
        }
}
