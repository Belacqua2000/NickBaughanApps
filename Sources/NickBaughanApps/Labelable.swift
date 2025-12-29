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
    
//    @ViewBuilder
    var label: some View {
//        switch image {
//        case .systemName(let title): Label(self.title, systemImage: title)
//        case .name(let title): Label(self.title, image: title)
//        case .character(let character):
            Label {
                Text(self.title)
            } icon: {
                self.image.image
            }
//        }
    }
    
    var imageName: String? {
        image.imageName
    }
}

public enum LabelableImage {
    case systemName(String)
    case name(String)
    case character(Character)
    
    var imageName: String? {
        switch self {
        case .systemName(let title): title
        case .name(let title): title
        case .character: nil
        }
    }
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .systemName(let title): Image(systemName: title)
        case .name(let title): Image(title)
        case .character(let character): Text(String(character))
        }
    }
}
