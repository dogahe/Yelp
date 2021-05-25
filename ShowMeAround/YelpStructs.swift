//
//  YelpStructs.swift
//  ShowMeAround
//
//  Created by Behzad Dogahe on 5/24/21.
//

import Foundation

struct YelpBusinessResponse: Decodable {
    let businesses: [YelpBusiness]
    let total: Int
}

struct YelpBusiness: Decodable {
    let id: String
    let name: String
    let image_url: String
    let url: String
    let coordinates: YelpCoordinats
    let rating: Double
    let review_count: Int
    let distance: Double
    let location: YelpLocation
}

struct YelpCoordinats: Decodable {
    let latitude: Double
    let longitude: Double
}

struct YelpLocation: Decodable {
    let display_address: [String]
}
