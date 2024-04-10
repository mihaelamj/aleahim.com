//
//  ContactMe.swift
//
//
//  Created by Mihaela MJ on 05.04.2024..
//

import Foundation

struct ContactMe {
    let title: String
    let url: String
    let icon: String
}

extension ContactMe {
    static var myLocation: ContactMe {
        return ContactMe(
            title: "🌍 Zagreb, Croatia",
            url: "https://hr.wikipedia.org/wiki/Zagreb",
            icon: "fas fa-map-marker-alt")
    }
    
    
    //This is your email info
    static var email: ContactMe {
        return ContactMe(
            title: "✉️ Email",
            url: "mailto:mihaelamj@gmail.com",
            icon: "fas fa-envelope-open-text")
    }
    
    //This is your LinkedIn page info
    static var linkedIn: ContactMe {
        return ContactMe(
            title: "🔗 LinkedIn",
            url: "https://www.linkedin.com/in/mihaelamj/",
            icon: "fab fa-linkedin"
        )
    }
    
    //This is your YouTube page info
    static var youTube: ContactMe {
        return ContactMe(
            title: "🔗 YouTube",
            url: "https://www.youtube.com/channel",
            icon: "fab fa-youtube"
        )
    }
    
    //This is your Twitter page info
    static var twitter: ContactMe {
        return ContactMe(
            title: "🔗 Twitter",
            url: "https://twitter.com/civeljahim",
            icon: "fab fa-twitter-square"
        )
    }
}
