import Foundation

public extension Project {
    var period: Period {
        switch self {
        case .tito:
            return .init(start: .init(month: 9, year: 2013), end: .init(month: 12, year: 2013))
        case .wogibtswas:
            return .init(start: .init(month: 12, year: 2013), end: .init(month: 1, year: 2014))
        case .bladesoho:
            return .init(start: .init(month: 1, year: 2014), end: .init(month: 4, year: 2014))
        case .coachlette:
            return .init(start: .init(month: 5, year: 2014), end: .init(month: 6, year: 2014))
        case .kindergarten:
            return .init(start: .init(month: 7, year: 2014), end: .init(month: 7, year: 2014))
        case .whatt:
            return .init(start: .init(month: 7, year: 2014), end: .init(month: 10, year: 2014))
        case .christresources:
            return .init(start: .init(month: 11, year: 2014), end: .init(month: 2, year: 2015))
        case .consumr:
            return .init(start: .init(month: 3, year: 2015), end: .init(month: 1, year: 2018))
        case .qrcode:
            return .init(start: .init(month: 2, year: 2017), end: .init(month: 10, year: 2018))
        case .shopsavvy:
            return .init(start: .init(month: 2, year: 2016), end: .init(month: 10, year: 2018))
        case .birthdayrama:
            return .init(start: .init(month: 11, year: 2018), end: .init(month: 1, year: 2019))
        case .huxly:
            return .init(start: .init(month: 2, year: 2019), end: .init(month: 5, year: 2019))
        case .breckWorld:
            return .init(start: .init(month: 6, year: 2019), end: .init(month: 8, year: 2019))
        case .servicepal:
            return .init(start: .init(month: 5, year: 2019), end: .init(month: 6, year: 2019))
        case .wheelsup:
            return .init(start: .init(month: 7, year: 2019), end: .init(month: 8, year: 2020))
        case .budtz:
            return .init(start: .init(month: 9, year: 2020), end: .init(month: 11, year: 2020))
        case .birch:
            return .init(start: .init(month: 8, year: 2020), end: .init(month: 10, year: 2022))
        case .zumiez:
            return .init(start: .init(month: 11, year: 2022), end: .init(month: 6, year: 2024))
        case .responsumchat:
            return .init(start: .init(month: 7, year: 2024), end: .init(month: 11, year: 2024))
        case .germanProject:
            return .init(start: .init(month: 5, year: 2024), end: .init(month: 12, year: 2024))
        case .irobot:
            return .init(start: .init(month: 12, year: 2024), end: .init(month: 3, year: 2025))
        }
    }
}
