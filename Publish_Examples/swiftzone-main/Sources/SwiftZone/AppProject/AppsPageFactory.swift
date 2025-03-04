//
//  AppsPageFactory.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish

struct AppsPageFactory {
  func makePage(fromApps apps: [AppProject]) -> Page {
    .init(path: "apps", content: .init(title: "Apps", description: "", body: makeBody(fromApps: apps)))
  }
  
  private func makeBody(fromApps apps: [AppProject]) -> Content.Body { .init(
    node: .ul(.id("apps-list"), .forEach(apps.sorted { $0.order < $1.order }.enumerated()) { index, app in
      .li(.if(!(index + 1).isMultiple(of: 2), .class("reverse")),
        .div(.class("app-details"),
          .h2(.text(app.name)),
          .div(.class("app-description"), .raw(app.descriptionHTML)),
          .unwrap(app.link) { .a(.target(.blank), .href($0), .img(.src("/app-store-badge.svg"))) }
        ),
        .img(.class("app-image"), .src(app.image))
      )
    })
  )}
}
