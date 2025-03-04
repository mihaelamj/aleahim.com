//
//  DefaultHTMLFactory.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish
import Plot


struct DefaultHTMLFactory<Site: Website>: HTMLFactory {
  let stylesheetPaths: [Path] = [
    "/DefaultTheme/styles.css",
    "https://use.typekit.net/fof8oqj.css"
  ]
  var additionalStylesheetPaths: [Path] = []
  var pagePaths: [Path] = []
  var contentPagePaths: [Path] = []
  var navigationLinks: [DefaultNavigationLink] = []
  var copyright: String
  var twitterURL: URLRepresentable?
  var githubURL: URLRepresentable?
  
  private let titleSeparator = " • "
  
  func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
    try makeIndexHTML(for: index, context: context, selectedSection: context.sections.ids.first)
  }
  
  func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
    try makeIndexHTML(for: context.index, context: context, selectedSection: section.id)
  }
  
  func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML { .init(
    .lang(context.site.language),
    .head(for: item, on: context.site, titleSeparator: titleSeparator, stylesheetPaths: stylesheetPaths + additionalStylesheetPaths),
    .body(
      .header(for: context, pagePaths: pagePaths, navigationLinks: navigationLinks, selectedSection: item.sectionID),
      .main(.article(.class("content"), .id("item-page-content"),
        .h1(.text(item.title)),
        .element(named: "time", nodes: [.id("item-page-date"),
            .text(DateFormatter.localizedString(from: item.date, dateStyle: .full, timeStyle: .none))]),
        .contentBody(item.body.removingH1())
      )),
      .div(.class("spacer")),
      .footer(copyright: copyright, twitterURL: twitterURL, githubURL: githubURL)
    )
  )}
  
  func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML { .init(
    .lang(context.site.language),
    .head(for: page, on: context.site, titleSeparator: titleSeparator, stylesheetPaths: stylesheetPaths + additionalStylesheetPaths),
    .body(
      .header(for: context, pagePaths: pagePaths, navigationLinks: navigationLinks, selectedPage: page),
      .main(.id("page"), .if(contentPagePaths.contains(page.path), .class("content")),
        .contentBody(page.body.removingH1())),
      .div(.class("spacer")),
      .footer(copyright: copyright, twitterURL: twitterURL, githubURL: githubURL)
    )
  )}
  
  func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? { nil }
  func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? { nil }
  
  private func makeIndexHTML(for index: Index, context: PublishingContext<Site>, selectedSection: Site.SectionID?) throws -> HTML { .init(
    .lang(context.site.language),
    .head(for: index, on: context.site, titleSeparator: titleSeparator, stylesheetPaths: stylesheetPaths + additionalStylesheetPaths),
    .body(
      .header(for: context, pagePaths: pagePaths, navigationLinks: navigationLinks, selectedSection: selectedSection),
      .ul(.id("item-list"),
        .forEach(context.allItems(sortedBy: \.date, order: .descending)) { item in
          .li(
            .div(.class("item-title"), .a(
              .href(item.path),
              .text(item.title)
            )),
            .div(.class("item-date"),
                 .text(DateFormatter.localizedString(from: item.date, dateStyle: .full, timeStyle: .none)),
                 .text(" - \(item.readingTime.minutes) minutes lecture.")
            ),
            .p(.text(item.description)),
            .a(.class("read-more"), .href(item.path), .text("Read more..."))
          )
        }),
      .div(.class("spacer")),
      .footer(copyright: copyright, twitterURL: twitterURL, githubURL: githubURL)
    )
  )}
}




