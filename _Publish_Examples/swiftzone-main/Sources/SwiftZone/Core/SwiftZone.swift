//
//  SwiftZone.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish
import Plot

enum SwiftZone {
  struct com: Website {
    var url = URL(string: "https://swiftzone.dev")!
    var name = "SwiftZone.dev"
    var description = "Sharing my interests in Swift, iOS, Apple & more by Asiel Cabrera"
    var language: Language { .english }
    var imagePath: Path? { "/images/website.png" }
  }
}
