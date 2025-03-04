//
//  Theme+Default.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish
import Plot

extension Theme {
  static func `default`(
    additionalStylesheetPaths: [Path] = [],
    pagePaths: [Path] = [],
    contentPagePaths: [Path] = [],
    navigationLinks: [DefaultNavigationLink] = [],
    copyright: String,
    twitterURL: URLRepresentable? = nil,
    githubURL: URLRepresentable? = nil) -> Self {
    Theme(htmlFactory: DefaultHTMLFactory(
      additionalStylesheetPaths: additionalStylesheetPaths,
      pagePaths: pagePaths,
      contentPagePaths: contentPagePaths,
      navigationLinks: navigationLinks,
      copyright: copyright,
      twitterURL: twitterURL,
      githubURL: githubURL
    ))
  }
}


