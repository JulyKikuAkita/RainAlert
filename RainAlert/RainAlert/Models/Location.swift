//
//  Location.swift
//  RainAlert
//
//  Created by July on 1/16/19.
//  Copyright © 2019 July. All rights reserved.
//

struct Location: Codable {
    let city: String
    let observation: [Observation]
    let country: String
    let distance: Int
    let latitude: Double
    let longitude: Double
    let state: String
    let timezone: Int
}
