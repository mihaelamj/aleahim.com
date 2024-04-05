//
//  DemoTheme.swift
//
//
//  Created by Mihaela MJ on 05.04.2024..
//

import Foundation
import Publish
import Plot

extension Theme where Site == AleahimCom {
    static var demoTheme: Self {
        Theme(htmlFactory: DemoHTMLFactory())
    }
}

struct DemoHTMLFactory: HTMLFactory {
    typealias Site = AleahimCom
    
    func makeIndexHTML(for index: Publish.Index, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .posts(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site,
                        title: "Recent posts"
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeSectionHTML(for section: Publish.Section<AleahimCom>, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .pageContent(.h1(.text(section.title))),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeItemHTML(for item: Publish.Item<AleahimCom>, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .post(for: item, on: context.site),
                    .footer(for: context.site)
                )
                
            )
        )
    }
    
    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .page(for: page, on: context.site),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .pageContent(
                        .tagList(for: page, on: context.site)
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<AleahimCom>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .header(for: context.site),
                    .sidebar(for: context.site),
                    .posts(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site,
                        title: "\(page.tag.string.capitalized) posts"
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    
    
}
