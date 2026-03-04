//
//  CloseButton.swift
//  Chronoderm
//
//  Created by Nick Baughan on 04/09/2022.
//

import SwiftUI

public struct CloseButton: CustomizableToolbarContent {
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
    @Environment(\.isPresented) private var isPresented
    
    var title: String = String(localized: "Done", bundle: .module, comment: "The title of the close button.")
    
    var placement: ToolbarItemPlacement = {
        #if os(watchOS)
        .cancellationAction
        #elseif os(macOS)
        .confirmationAction
        #else
        .automatic
        #endif
    }()
    
    public var body: some CustomizableToolbarContent {
        if isPresented {
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *) {
                ToolbarItem(id: "Close", placement: placement) {
                    Button(role: .close, action: dismiss.callAsFunction)
                }
            } else {
                ToolbarItem(id: "Close", placement: placement) {
                    
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
    }
}

#Preview {
    Color.blue
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                Color.pink
                    .ignoresSafeArea()
                    .toolbar(content: CloseButton.init)
            }
        }
}
