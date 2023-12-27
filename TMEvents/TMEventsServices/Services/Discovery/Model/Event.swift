//
//  Event.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

struct DiscoveryEvents: Decodable {
    let embedded: EmbeddedEvents

    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Decodable {
    let events: [Event]
}

struct Event: Decodable {
    let name: String?
    let type: String?
    let id: String?
    let url: String?
    let locale: String?
    let images: [Image]?
    let dates: EventDate?
    let embedded: Embedded?

    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case name, type, id, url, locale, images, dates
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(String.self, forKey: .name)
        type = try? container.decode(String.self, forKey: .type)
        id = try? container.decode(String.self, forKey: .id)
        url = try? container.decode(String.self, forKey: .url)
        locale = try? container.decode(String.self, forKey: .locale)
        images = try? container.decode([Image].self, forKey: .images)
        dates = try? container.decode(EventDate.self, forKey: .dates)
        embedded = try? container.decode(Embedded.self, forKey: .embedded)
    }
}

struct Image: Decodable {
    let ratio: String?
    let url: String?
    let width: Int?
    let height: Int?
    let fallback: Bool?
}

struct EventDate: Decodable {
    let start: DateDetail?
    let timezone: String?
}

struct DateDetail: Decodable {
    let localDate: String?
    let localTime: String?
    let dateTime: String?
}

struct Embedded: Decodable {
    let venues: [Venue]?
}

struct Venue: Decodable {
    let id: String?
    let name: String?
    let url: String?
    let city: City?
    let state: State?
}

struct City: Decodable {
    let name: String?
}

struct State: Decodable {
    let name: String?
    let stateCode: String?
}
