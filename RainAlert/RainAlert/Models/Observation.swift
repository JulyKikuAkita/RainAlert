//
//  Observation.swift
//  RainAlert
//
//  Created by July on 1/16/19.
//  Copyright © 2019 July. All rights reserved.
//

struct Observation: Codable {
    let description: String
    let precipitationDesc: String
    let skyDescription: String
    let ageMinutes: Int
    let highTemperature: Double
    let longitude: Double
    let snowCover: String
    let windSpeed: Double
    let windDesc: String
}
