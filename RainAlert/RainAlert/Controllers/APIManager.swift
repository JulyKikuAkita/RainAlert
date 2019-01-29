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
    var hereSampleWeatherAPIURL = "https://weather.cit.api.here.com/weather/1.0/report.json?product=observation&zipcode=94403&oneobservation=true&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"
    func composeHereURL(product: String, zipcode: String, app_id: String, app_code: String) -> String {
        let hereDomain = "https://weather.cit.api.here.com/weather/1.0/report.json?"
        let amp = "&"
        let url = hereDomain
        + "product=\(product)" + amp
        + "zipcode=\(zipcode)" + amp
        + "oneobservation=true" + amp
        + "app_id=\(app_id)" + amp
        + "app_code=\(app_code)"
        print (url == hereSampleWeatherAPIURL)
        return url;
    }
    
    func setHereAPIREquestURL(zipcode: Int) {
        self.hereSampleWeatherAPIURL = composeHereURL(product: "observation", zipcode: String(zipcode), app_id: "DemoAppId01082013GAL", app_code: "AJKnXv84fjrb0KIHawS0Tg")
    }
    
    func getObserveOneJsonTopLevel(completion: @escaping (_ observation: ObserveOneJsonTopLevel?, _ error: Error?) -> Void) {
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
    
    private func createWeatherObjectWith(json: Data, completion: @escaping (_ data: ObserveOneJsonTopLevel?, _ error: Error?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let observeOneJsonTopLevel = try decoder.decode(ObserveOneJsonTopLevel.self, from: json)
            debugPrint(observeOneJsonTopLevel)
            return completion(observeOneJsonTopLevel, nil)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
            return completion(nil, error)
        }
    }
}
