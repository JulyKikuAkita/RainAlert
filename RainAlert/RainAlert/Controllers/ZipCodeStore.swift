//
//  ZipCodeStore.swift
//  RainAlert
//
//  Created by July on 1/28/19.
//  Copyright © https://medium.com/yay-its-erica/validating-us-zip-codes-swift-3-a9f01adec125
//
import Foundation

struct ZipCodeStore {
    static func readJson(completion: @escaping ([Int]) -> Void) {
        do {
            if let file = Bundle.main.url(forResource: "zipcodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: [Int]] {
                    if let zipArray = object["zip"] {
                        completion(zipArray)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
