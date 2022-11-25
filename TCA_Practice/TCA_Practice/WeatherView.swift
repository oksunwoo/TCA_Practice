//
//  WeatherView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/25.
//

import SwiftUI
import ComposableArchitecture

struct Weather: ReducerProtocol {
    struct State: Equatable {
        var latitude: Double = 0
        var longitude: Double = 0
        var isWeatherRequest = false
        var result: String?
    }
    
    enum Action: Equatable {
        case confirmButtonTapped
        case weatherResponse(TaskResult<String>)
    }
    
    @Dependency(\.weatherClient) var weatherClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .confirmButtonTapped:
            state.isWeatherRequest = true
            state.result = nil
            
            return .task { [latitude = state.latitude, longitude = state.longitude] in
                await .weatherResponse(TaskResult { try await
                    self.weatherClient.fetch(latitude, longitude)
                })
            }
            
        case .weatherResponse(.success(let response)):
            state.isWeatherRequest = false
            state.result = response

            return .none
            
        case .weatherResponse(.failure):
            state.isWeatherRequest = false
            
            return .none
        }
    }
}

struct WeatherView: View {
    let store: StoreOf<Weather>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherView(store: Store(initialState: Weather.State(), reducer: Weather()))
        }
    }
}
