//
//  FormViewDescription.swift
//  Chronoderm
//
//  Created by Nick Baughan on 27/12/2022.
//

import SwiftUI

public struct FormViewDescription: View {
    public init(imageName: String, description: AttributedString) {
        self.imageName = imageName
        self.description = description
    }
    
    var imageName: String
    var description: AttributedString
    public var body: some View {
        Section { } footer: {
            InformationView(iconName: imageName, subtitle: Text(description))
                .foregroundStyle(.primary)
        }
    }
}

struct FormViewDescription_Previews: PreviewProvider {
    static var previews: some View {
        FormViewDescription(imageName: "star", description: .init(localized: "Star"))
    }
}
