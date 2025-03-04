//
//  extension+Content.Body.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Publish
 
extension Content.Body {
  func removingOccurrences(of string: String) -> Self {
    .init(html: html.replacingOccurrences(of: string, with: "", options: .regularExpression))
  }
  
  func removingH1() -> Self {
    self.removingOccurrences(of: "<h1>.*</h1>")
  }
}
