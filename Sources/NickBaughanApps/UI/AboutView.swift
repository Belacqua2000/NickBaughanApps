//
//  AboutView.swift
//  Unthreaded
//
//  Created by Nick Baughan on 27/05/2025.
//

import SwiftUI
import DeveloperToolsSupport

@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct AboutView: View {
    
    public init(appTitle: String, frameworks: [OpenSourceFramework] = [], appIcon: String) {
        self.appTitle = appTitle
        self.frameworks = frameworks
        self.appIcon = .init(name: appIcon, bundle: .main)
    }
    
    
    var appTitle: String
    var frameworks: [OpenSourceFramework]
    var appIcon: ImageResource
    
    let buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    let versionNumber: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    @available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
    enum DeveloperImage: Identifiable {
        case wave, mac, heart
        var id: Self { self }
        
        var image: ImageResource {
            switch self {
            case .wave: .developerMemojiWave
            case .mac: .developerMemojiMacBook
            case .heart: .developerMemojiHeart
            }
        }
        
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
    
    @State private var selectedImage: DeveloperImage = .heart
    
    public var body: some View {
        Form {
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
                        .multilineTextAlignment(.center)
                }
                .accessibilityElement(children: .combine)
                .padding()
                .frame(maxWidth: .infinity)
                .focusable()
            }
            
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
            
            /* Section("Acknowledgements") {
             Text(
             """
             I am hugely grateful to the people below, who have informally given advice and tested this app.
             
             **Paul Baughan**
             """
             )
             LabeledContent("", value: "")
             }*/
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

#Preview {
    if #available (iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *) {
        AboutView(appTitle: "Cairns", frameworks: [], appIcon: "")
    }
}
