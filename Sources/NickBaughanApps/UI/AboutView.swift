//
//  AboutView.swift
//  Unthreaded
//
//  Created by Nick Baughan on 27/05/2025.
//

/// A view presenting detailed information about the app, including app metadata,
/// developer information, acknowledgements, and open-source frameworks used.
/// Supports iOS 17.0+, tvOS 17.0+, macOS 14.0+, and watchOS 10.0+.
import SwiftUI
import DeveloperToolsSupport

@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct AboutView: View {
    
    /// The title of the app, expected to be a localized string.
    var appTitle: String
    
    /// A collection of open-source frameworks used within the app.
    var frameworks: [OpenSourceFramework]
    
    /// The app icon image resource displayed in the about view.
    var appIcon: ImageResource
    
    /// The build number of the app, retrieved from the app bundle.
    let buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    
    /// The version number of the app, retrieved from the app bundle.
    let versionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    /// Creates an AboutView displaying information about the app.
    ///
    /// - Parameters:
    ///   - appTitle: The localized name of the app to display.
    ///   - frameworks: An array of open-source frameworks to acknowledge.
    ///   - appIcon: The name of the app icon asset to display.
    ///
    /// - Warning: The `appTitle` string must already be localized before passing in.
    public init(appTitle: String, frameworks: [OpenSourceFramework] = [], appIcon: String) {
        self.appTitle = appTitle
        self.frameworks = frameworks
        self.appIcon = .init(name: appIcon, bundle: .main)
    }
    
    /// An enumeration describing the developer's memoji images shown in the about view.
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    enum DeveloperImage: Identifiable {
        /// The waving memoji image.
        case wave
        /// The macbook memoji image.
        case mac
        /// The heart memoji image.
        case heart
        
        var id: Self { self }
        
        /// The image resource associated with each developer image case.
        var image: ImageResource {
            switch self {
            case .wave: .developerMemojiWave
            case .mac: .developerMemojiMacBook
            case .heart: .developerMemojiHeart
            }
        }
        
        /// Returns the next developer image in sequence.
        func nextImage() -> Self {
            switch self {
            case .wave:
                return .mac
            case .mac:
                return .heart
            case .heart:
                return .wave
            }
        }
    }
    
    /// The currently selected developer memoji image shown in the view.
    @State private var selectedImage: DeveloperImage = .heart
    
    /// The main view body presenting app info, developer details, acknowledgements,
    /// frameworks, and version data in a grouped form.
    public var body: some View {
        Form {
            /// Section displaying app icon, title, and a short tagline.
            Section {
                VStack {
                    Image(appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        #if os(iOS) || os(macOS) || os(tvOS)
                        .clipShape(.rect(cornerRadius: 20))
                        #elseif os(watchOS) || os(visionOS)
                        .clipShape(.circle)
                        #endif
                        .frame(width: 80)
                        .accessibilityHidden(true)
                    //                    .listRowBackground(EmptyView())
                    Text(appTitle)
                        .font(.system(.title, weight: .bold))
                    Text("Designed and built with love from Scotland 🏴󠁧󠁢󠁳󠁣󠁴󠁿")
                }
                .multilineTextAlignment(.center)
                .accessibilityElement(children: .combine)
                .padding()
                .frame(maxWidth: .infinity)
                .focusable()
            }
            
            /// Section presenting developer information including an interactive image, biography text, and a contact link.
            Section("Developer") {
                Button {
                    withAnimation { self.selectedImage = self.selectedImage.nextImage() }
                } label: {
                    ZStack {
                        Circle().fill(.gray.opacity(0.5).gradient)
                        Image(selectedImage.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    .frame(height: 156)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderless)
                .listRowSeparator(.hidden)
                .accessibilityHidden(true)
                
                Text(
                    """
                    I am an independent app developer and have been passionate about software from a young age. Since 2019, I have been teaching myself app development, and strive to make simple and intuitive apps in my free time.
                    
                    *Nick Baughan*
                    """
                )
                .selectable()
                #if !os(tvOS)
                Link(destination: .developerWebsite) {
                    Label("Get in Touch", systemImage: "hand.wave")
                }
                #endif
            }
            
            /// Section listing open-source frameworks utilized by the app, if any.
            if !frameworks.isEmpty {
                Section {
                    ForEach(frameworks) { framework in
                        VStack(alignment: .leading) {
                            Text(framework.title).bold()
                            Text(framework.license.string).font(.footnote)
                            Text(framework.description).foregroundStyle(.secondary)
                            Link(framework.url.host()!, destination: framework.url).font(.footnote)
                                .buttonStyle(.borderless)
                                .accessibilityLabel("\(framework.title) Website")
                        }
                        .accessibilityElement(children: .combine)
                    }
                } header: {
                    Text("Open-Source Frameworks")
                } footer: {
                    Text("I'm very grateful for these tools that help to make \(appTitle) possible.")
                }
            }
            
            /// Section displaying version and build number information.
            Section("Version") {
                LabeledContent("Version", value: versionNumber)
                    .selectable()
                LabeledContent("Build", value: buildNumber)
                    .selectable()
            }
        }
        //        .focusable()
        #if !os(macOS)
        .navigationTitle("About")
        #endif
        .formStyle(.grouped)
    }
}

/// SwiftUI preview provider for AboutView, used for design and testing in Xcode previews.
#Preview {
    if #available (iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *) {
        AboutView(appTitle: "Cairns", frameworks: [], appIcon: "")
    }
}
