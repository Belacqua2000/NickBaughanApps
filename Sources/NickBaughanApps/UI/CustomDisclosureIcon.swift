//
//  CustomDisclosureIcon.swift
//  Hills
//
//  Created by Nick Baughan on 01/02/2026.
//

import SwiftUI

public struct CustomDisclosureIcon: View {
    public init() { }
    
    public var body: some View {
        Image(systemName: "chevron.right")
            .imageScale(.small)
            .foregroundStyle(.secondary)
    }
}
