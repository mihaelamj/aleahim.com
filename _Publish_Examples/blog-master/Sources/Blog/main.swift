import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://bmarkowitz.github.io")!
    var name = "Brett Markowitz"
    var description = "A blog for random stuff"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Blog()
    .publish(
        withTheme: .foundation,
        deployedUsing: .gitHub("bmarkowitz/bmarkowitz.github.io", useSSH: true),
        plugins: [.splash(withClassPrefix: "")]
    )
