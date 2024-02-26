//
//  MapModel.swift
//  CoreLocationPock
//
//  Created by user on 21/02/24.
//

import Foundation

struct AddressResultModel: Codable {
    let results: [AdressData]
    let status: String
}

struct AdressData: Codable {
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: MapModelGeometry

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
    }
}

struct AddressComponent: Codable {
    let longName: String
    let shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct MapModelGeometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
