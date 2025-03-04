//
//  TopicPublishingStep.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Foundation
import Publish

extension PublishingStep where Site == SwiftZone.com {
    static func checkTopics() -> Self {
        .step(named: "CheckTopics") { context in
            Topic.checkTopics(context: context)
        }
    }
}
