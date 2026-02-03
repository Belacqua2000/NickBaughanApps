//
//  File.swift
//  
//
//  Created by Nick Baughan on 08/08/2024.
//

import Foundation

public extension URL {
    /**
     The official developer website URL.
     */
    static let developerWebsite: Self = URL(string: "https://nickbaughan.com")!
    /**
     The privacy policy URL for the application.
     */
    static let privacyPolicy: Self = URL(string: "https://nickbaughan.com/privacy-policy")!
    /**
     A mailto: URL for the developer support email address.
     
     Use ``prefilledSupportEmail(subject:body:)`` to customise the contents of the email.
     */
    static let supportEmail: Self = URL(string: "mailto:support@nickbaughan.com")!
    
    
    /// The URL to Apple's End License User Agreement.
    static let appleEULA = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    
    /// The URL to Apple's accessibility website.
    static let appleAccessibilityInfo = URL(string: "https://support.apple.com/en-gb/guide/iphone/iph3e2e4367/ios")!
    
    /**
     Returns a mailto: URL for support prefilled with diagnostic information and optional subject/body.

     - Parameters:
        - subject: The email subject line. Defaults to "App Support".
        - body: The initial email body content. If nil, body starts empty.
     - Returns: A mailto: URL containing the filled-out subject and body, including app and device diagnostic info.
     */
    static func prefilledSupportEmail(subject: String = "App Support", body: String? = nil) -> Self {
        let buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        let versionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let body =
        """
        \(body ?? "")
        
        Including the device information below may help with your query.
        App Version: \(versionNumber)
        App Build: \(buildNumber)
        Locale: \(Locale.current)
        Region: \(Locale.current.region?.identifier ?? "None")
        Device: \(modelIdentifier)
        OS Version: \(ProcessInfo.processInfo.operatingSystemVersionString)
        """
        
        let recipients = ["support@nickbaughan.com"]

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = recipients.joined(separator: ",")
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]

        return components.url ?? .supportEmail
    }
}

/**
 Returns the model identifier for the current device (e.g., hardware model on macOS or device identifier on iOS family).
 */
fileprivate var modelIdentifier: String {
#if os(macOS)
    var size: size_t = 0
    sysctlbyname("hw.model", nil, &size, nil, 0)
    var machine = [CChar](repeating: 0, count: Int(size))
    sysctlbyname("hw.model", &machine, &size, nil, 0)
    return String(cString: &machine, encoding: .utf8) ?? ""
    
    #else
    var systemInfo = utsname()
    uname(&systemInfo)
    return withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(cString: $0)
        }
    }
    #endif
}
