//
//  VersionBuilder.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 12/02/2026.
//

import Foundation

/// A result builder for constructing Version arrays using a DSL syntax.
@resultBuilder
public struct VersionBuilder {
    public static func buildBlock(_ components: Version...) -> [Version] {
        components
    }
    
    public static func buildArray(_ components: [[Version]]) -> [Version] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [Version]?) -> [Version] {
        component ?? []
    }
    
    public static func buildEither(first component: [Version]) -> [Version] {
        component
    }
    
    public static func buildEither(second component: [Version]) -> [Version] {
        component
    }
}
