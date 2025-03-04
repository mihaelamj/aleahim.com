//
//  Footer.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func footer(copyright: String, twitterURL: URLRepresentable?, githubURL: URLRepresentable?) -> Node {
    .footer(
      .div(.class("divider")),
      .div(.id("footer-content"),
        .p("Copyright © ", .script("document.write(new Date().getFullYear())"), " \(copyright)"),
        .div(
          .unwrap(twitterURL) { .a(.class("social-icon"), .target(.blank), .href($0), .img(.src("/DefaultTheme/twitter.svg"))) },
          .unwrap(githubURL) { .a(.class("social-icon"), .target(.blank), .href($0), .img(.src("/DefaultTheme/github.svg"))) }
        )
      )
    )
  }
}
