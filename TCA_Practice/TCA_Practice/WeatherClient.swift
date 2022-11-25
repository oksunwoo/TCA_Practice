//
//  WeatherClient.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/24.
//

import Foundation
import ComposableArchitecture

struct WeatherClient {
    var fetch: @Sendable (Double, Double) async throws -> String
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
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=0c9597f339213a09976a39e4c6f49cc5")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}
