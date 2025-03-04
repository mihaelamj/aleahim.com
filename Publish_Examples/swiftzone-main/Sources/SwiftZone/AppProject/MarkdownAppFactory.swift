//
//  MarkdownAppFactory.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish
import Files
import Ink

struct MarkdownAppFactory {
  var parser = MarkdownParser()
  
  enum MarkdownAppFactoryError: Error {
    case missingRequiredMetadata
  }
  
  func makeApp(fromFile file: File) throws -> AppProject {
    let markdown = try parser.parse(file.readAsString())
    guard let image = markdown.metadata["image"]
    else { throw MarkdownAppFactoryError.missingRequiredMetadata }
    return AppProject(
      name: markdown.metadata["name"] ?? file.nameExcludingExtension,
      image: image, link: markdown.metadata["link"],
      descriptionHTML: markdown.html,
      order: markdown.metadata["order"].flatMap(Int.init) ?? 0)
  }
}
