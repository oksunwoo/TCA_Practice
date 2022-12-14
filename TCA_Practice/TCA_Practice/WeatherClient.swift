//
//  WeatherClient.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/24.
//

import Foundation
import ComposableArchitecture

struct WeatherClient {
    var fetch: @Sendable (Double, Double) async throws -> WeatherInformation?
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}

extension WeatherClient: DependencyKey {
    static let liveValue = WeatherClient(
        fetch: { lat, lon in
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=")!)
            
            let parsedData = JsonParser.decode(from: data)
            return parsedData
        }
    )
}
