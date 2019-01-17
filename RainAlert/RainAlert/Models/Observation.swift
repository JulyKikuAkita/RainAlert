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
    let temperatureDesc: String
    let snowCover: String
    let windDesc: String
    let latitude: Double
    let longitude: Double
}
