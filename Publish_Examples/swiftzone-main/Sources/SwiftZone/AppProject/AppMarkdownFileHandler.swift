//
//  AppMarkdownFileHandler.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish
import Files

struct AppMarkdownFileHandler<Site: Website> {
  var markdownAppFactory = MarkdownAppFactory()
  var appsPageFactory = AppsPageFactory()
  
  func addMarkdownFiles(in folder: Folder, to context: inout PublishingContext<Site>) throws {
    let apps = try folder.files.map(markdownAppFactory.makeApp)
    context.addPage(appsPageFactory.makePage(fromApps: apps))
  }
}
