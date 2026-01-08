//
//  OpenSourceFramework.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 06/11/2025.
//

import Foundation

/// A model describing an open-source framework used in the app.
///
/// Use this type to present information about third‑party dependencies, including
/// their title, a short description, a homepage URL, and the applicable license.
/// Conforms to `Identifiable` (using `title` as a stable identifier) and `Sendable`
/// for use across concurrency domains.
public struct OpenSourceFramework: Identifiable, Sendable {
    /// Creates a new `OpenSourceFramework` value.
    /// - Parameters:
    ///   - title: The display name of the framework. Also used as the identifier.
    ///   - description: A short human‑readable summary of the framework.
    ///   - url: The canonical URL for the framework (e.g. repository or homepage).
    ///   - license: The license under which the framework is distributed.
    public init(title: String, description: String, url: URL, license: License) {
        self.title = title
        self.description = description
        self.url = url
        self.license = license
    }
    
    /// The identifier for this framework, derived from `title`.
    public var id: String { title }
    
    /// The display name of the framework.
    public let title: String
    
    /// A short summary describing the framework.
    public let description: String
    
    /// The canonical homepage or repository URL for the framework.
    public let url: URL
    
    /// The license that applies to the framework.
    public let license: License
    
    /// A software license associated with an open‑source framework.
    public enum License: Sendable {
        /// Apache License, Version 2.0.
        case apache20
        /// MIT License.
        case mit
        /// Creative Commons Attribution 4.0 International (CC BY 4.0).
        case creativeCommonsBY40
        /// An unrecognized license with a custom display string.
        case unknown(String)
        
        /// A human‑readable name for the license.
        public var string: String {
            switch self {
            case .apache20: return "Apache License 2.0"
            case .mit: return "MIT License"
            case .creativeCommonsBY40: return "CC BY 4.0"
            case .unknown(let string): return string
            }
        }
    }
}
