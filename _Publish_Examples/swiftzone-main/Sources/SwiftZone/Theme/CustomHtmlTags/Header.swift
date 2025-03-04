//
//  Header.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func header<Site: Website>(for context: PublishingContext<Site>, pagePaths: [Path] = [], navigationLinks: [DefaultNavigationLink] = [], selectedSection: Site.SectionID? = nil, selectedPage: Page? = nil) -> Node {
        .header(
            .div(.id("title"), .a(.href("/"), .text(context.site.name))),
            .div(.id("subtitle"), .text(context.site.description)),
            .div(.class("divider")),
            .nav(.ul(
                .forEach(Site.SectionID.allCases) { section in
                        .li(.a(
                            .class(section == selectedSection ? "selected" : ""),
                            .href("/"),
                            .text(context.sections[section].title.uppercased())
                        ))
                },
                .forEach(pagePaths.compactMap { context.pages[$0] }) { page in
                        .li(.a(
                            .class(page == selectedPage ? "selected" : ""),
                            .href(page.path),
                            .text(page.content.title.uppercased())
                        ))
                },
                .forEach(navigationLinks) { link in
                        .li(.a(.target(.blank), .href(link.url), .text(link.name.uppercased())))
                }
            ))
        )
    }
}
