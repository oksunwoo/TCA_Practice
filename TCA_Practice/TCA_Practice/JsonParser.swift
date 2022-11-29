//
//  JsonParser.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/28.
//

import Foundation

enum JsonParser {
    static func decode(from json: Data) -> WeatherInformation? {
        var weather: WeatherInformation?
        
        do {
            weather = try JSONDecoder().decode(WeatherInformation.self, from: json)
        } catch {
            print(error)
        }
        
        return weather
    }
}
