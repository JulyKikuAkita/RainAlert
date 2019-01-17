//
//  APIManager.swift
//  RainAlert
//
//  Created by July on 1/16/19.
//  Copyright © 2019 July. All rights reserved.
//
// source:https://blog.pusher.com/swift-4-decoding-json-codable/
// API: https://developer.here.com/api-explorer/rest/auto_weather/weather-observation-zipcode

import Foundation

class APIManager {
    let hereSampleWeatherAPIURL = "https://weather.cit.api.here.com/weather/1.0/report.json?product=observation&zipcode=94403&oneobservation=true&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"
    
    func getObservations(completion: @escaping (_ observation: Observations?, _ error: Error?) -> Void) {
        getJSONFromURL(urlString: hereSampleWeatherAPIURL) { (data, error) in
            guard let data = data, error == nil else {
                print("Failed to get data")
                return completion(nil, error)
            }
            self.createWeatherObjectWith(json: data, completion: { (observations, error) in
                if let error = error {
                    print("Failed to convert data")
                    return completion(nil, error)
                }
                return completion(observations, nil)
            })
        }
    }
}

extension APIManager {
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error: Cannot create URL from string")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                print("Error calling api")
                return completion(nil, error)
            }
            guard let responseData = data else {
                print("Data is nil")
                return completion(nil, error)
            }
            completion(responseData, nil)
        }
        task.resume()
    }
    
    private func createWeatherObjectWith(json: Data, completion: @escaping (_ data: Observations?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let observations = try decoder.decode(Observations.self, from: json)
            //TODO: Observations mapping error
            //debugDescription    String    "No value associated with key location (\"location\")."    
            dump(observations)
            return completion(observations, nil)
        } catch let error {
            print("Error creating current weather from JSON because: \(error.localizedDescription)")
            return completion(nil, error)
        }
    }
}
