//
//  AleahimCom.swift
//  
//
//  Created by Mihaela MJ on 09.04.2024..
//

import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct AleahimCom: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
        case resume
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://your-website-url.com")!
    var title = "(Aleahim) Mihaela's Site"
    var name = "Mihaela M."
    var description = "Senior iOS Dev, OpenAPI, FCP"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var contactMe: [ContactMe] { [.myLocation, .email, /*.youTube, */ .linkedIn, .twitter] }
}
