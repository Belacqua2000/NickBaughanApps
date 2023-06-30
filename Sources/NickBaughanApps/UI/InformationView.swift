//
//  InformationView.swift
//  Chronoderm
//
//  Created by Nick Baughan on 10/05/2023.
//

import SwiftUI

public struct InformationView: View {
    var iconName: String
    var title: String?
    var subtitle: Text?
    
    static var size: Double {
        #if os(watchOS)
        48
        #else
        64
        #endif
    }
    
    public var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: Self.size))
//                .foregroundStyle(.secondary)
                .symbolVariant(.fill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color("AccentColor2"))
                .accessibilityHidden(true)
            if let title {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(Color("AccentColor2"))
            }
            if let subtitle {
                subtitle
                    .foregroundStyle(.secondary)
                    .font(.body)
            }
        }
        .multilineTextAlignment(.center)
        #if !os(macOS)
        .padding()
        .frame(maxWidth: .infinity)
        #endif
    #if os(iOS)
        .listSectionSeparator(.hidden)
        .listSectionSeparatorTint(.clear)
    #endif
        .font(nil)
        .textCase(nil)
        .lineLimit(nil)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(iconName: "heart", title: "Favourites", subtitle: Text("No favourites"))
    }
}
