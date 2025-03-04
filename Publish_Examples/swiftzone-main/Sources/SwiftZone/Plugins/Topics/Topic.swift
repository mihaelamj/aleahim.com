//
//  Topic.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish

struct Topic {
    static func checkTopics(context: PublishingContext<SwiftZone.com>) {
        context.allItems(sortedBy: \.date).forEach { item in
            print(item.metadata.topic)
        }
    }
}

extension Plugin {
    static func checkTopics() -> Self where Site == SwiftZone.com {
        Plugin(name: "check topics") { context in
            Topic.checkTopics(context: context)
        }
    }
}
