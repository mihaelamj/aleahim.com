//
//  main.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish
import Plot
import SplashPublishPlugin



try SwiftZone.com().publish(withTheme: .default(
  additionalStylesheetPaths: ["/apps.css"],
  pagePaths: ["apps", "about"],
  contentPagePaths: ["about"],
  navigationLinks: [
//    .init(name: "Resume",
//          url: "https://s3.amazonaws.com/niazoff.com/resume.pdf")
  ],
  copyright: "Asiel Cabrera",
  twitterURL: "https://twitter.com/asiel_cabrera",
  githubURL: "https://github.com/asielcabrera"
), additionalSteps: [
//  .addAppMarkdownFiles()
    .installPlugin(.readingTime()),
    .installPlugin(.checkTopics())
], plugins: [
  .splash(withClassPrefix: ""),
  
])
