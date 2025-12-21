//
//  Labelable.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 21/12/2025.
//

import SwiftUI

public protocol Labelable {
    typealias Image = LabelableImage
    
    var title: String { get }
    var image: Image { get }
}

public extension Labelable {
    var label: some View {
        switch image {
        case .systemName(let title): Label(self.title, systemImage: title)
        case .name(let title): Label(self.title, image: title)
        }
    }
}

public enum LabelableImage {
    case systemName(String)
    case name(String)
}
