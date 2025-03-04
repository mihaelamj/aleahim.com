//
//  File.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish

extension PublishingStep {
  static func addAppMarkdownFiles(at path: Path = "Apps") -> Self {
    step(named: "Add page with app Markdown files from '\(path)' folder") { context in
      let folder = try context.folder(at: path)
      try AppMarkdownFileHandler().addMarkdownFiles(in: folder, to: &context)
    }
  }
}
