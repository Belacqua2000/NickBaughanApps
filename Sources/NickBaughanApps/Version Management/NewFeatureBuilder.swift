//
//  NewFeatureBuilder.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 12/02/2026.
//

/// A result builder for constructing NewFeature arrays using a DSL syntax.
@resultBuilder
public struct NewFeatureBuilder {
    public static func buildBlock(_ components: NewFeature...) -> [NewFeature] {
        components
    }
    
    public static func buildArray(_ components: [[NewFeature]]) -> [NewFeature] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [NewFeature]?) -> [NewFeature] {
        component ?? []
    }
    
    public static func buildEither(first component: [NewFeature]) -> [NewFeature] {
        component
    }
    
    public static func buildEither(second component: [NewFeature]) -> [NewFeature] {
        component
    }
}
