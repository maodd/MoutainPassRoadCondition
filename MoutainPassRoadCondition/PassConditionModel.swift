//
//  PassConditionModel.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-19.
//

import Foundation

struct Restriction : Decodable {
    let RestrictionText: String
    let TravelDirection: String
}

struct PassConditionModel : Decodable {
    let MountainPassId: Int
    let DateUpdated: String
    let ElevationInFeet: Int
    let Latitude: Double
    let Longitude: Double
    let MountainPassName: String
    let RestrictionOne: Restriction
    let RestrictionTwo: Restriction
    let RoadCondition: String
    let TemperatureInFahrenheit: Int?
    let TravelAdvisoryActive: Bool
    let WeatherCondition: String?
    
}
