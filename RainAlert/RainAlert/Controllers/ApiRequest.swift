//
//  ApiRequest.swift
//  RainAlert
//
//  Created by July on 1/15/19.
//  Copyright © 2019 July. All rights reserved.
//

// MARK: Reading https://matteomanferdini.com/network-requests-rest-apis-ios-swift/

//MARK: Weather API
// https://www.weather.gov/documentation/services-web-api
//Json format https://api.weather.gov/gridpoints/TOP/31,80/forecast/hourly

// need to check if it's free
// https://developer.here.com/api-explorer/rest/auto_weather/weather-observation-zipcode
// https://developer.here.com/projects/PROD-048aeff5-06da-46d2-9af5-5b00a86a4256

import Foundation


class ApiRequest {
    let weatherAPIURL = "https://weather.cit.api.here.com/weather/1.0/report.json?product=observation&zipcode=94403&oneobservation=true&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"
    
    func printObservationJsonArray(){
        guard let url = URL(string: weatherAPIURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
