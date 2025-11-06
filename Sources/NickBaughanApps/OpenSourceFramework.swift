//
//  OpenSourceFramework.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 06/11/2025.
//

import Foundation

struct OpenSourceFramework: Identifiable {
    var id: String { title }
    let title: String
    let description: String
    let url: URL
    let license: License
    
    enum License {
        case apache20
        case mit
        case unknown(String)
        
        var string: String {
            switch self {
            case .apache20: return "Apache License 2.0"
            case .mit: return "MIT License"
            case .unknown(let string): return string
            }
        }
    }
}
