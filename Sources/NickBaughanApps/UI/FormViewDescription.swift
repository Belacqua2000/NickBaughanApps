//
//  SettingsDescriptions.swift
//  Chronoderm
//
//  Created by Nick Baughan on 27/12/2022.
//

import SwiftUI

public struct SettingsDescriptions: View {
    var imageName: String
    var description: AttributedString
    public var body: some View {
        Section { } footer: {
            InformationView(iconName: imageName, subtitle: Text(description))
                .foregroundStyle(.primary)
        }
    }
}

struct SettingsDescriptions_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDescriptions(imageName: "star", description: .init(localized: "Star"))
    }
}
