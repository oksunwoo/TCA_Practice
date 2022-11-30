//
//  WeatherView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/25.
//

import SwiftUI
import ComposableArchitecture

struct Weathers: ReducerProtocol {
    struct State: Equatable {
        var latitude: String = ""
        var longitude: String = ""
        var isWeatherRequest = false
        var result: WeatherInformation?
    }
    
    enum Action: Equatable {
        case confirmButtonTapped
        case weatherResponse(TaskResult<WeatherInformation>)
        case longitudeTextInput(String)
        case latitudeTextInput(String)
    }
    
    @Dependency(\.weatherClient) var weatherClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .confirmButtonTapped:
            state.isWeatherRequest = true
            state.result = nil
            
            return .task { [latitude = state.latitude, longitude = state.longitude] in
                await .weatherResponse(TaskResult { try await
                    self.weatherClient.fetch(Double(latitude)!, Double(longitude)!)!
                })
            }
        case .longitudeTextInput(let longitude):
            state.longitude = longitude
            
            return .none
            
        case .latitudeTextInput(let latitude):
            state.latitude = latitude
            
            return .none
            
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
    let store: StoreOf<Weathers>
 
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    HStack {
                        VStack {
                            TextField("Enter longitude", text: viewStore.binding(get: \.longitude, send: Weathers.Action.longitudeTextInput))
                            TextField("Enter latitude", text: viewStore.binding(get: \.latitude, send: Weathers.Action.latitudeTextInput))
                            Button {
                                viewStore.send(.confirmButtonTapped)
                            } label: {
                                Text("Confirm")
                            }
                            .buttonStyle(.bordered)
                        }
                        .textFieldStyle(.roundedBorder)
                    }
                }
                
                Section {
                    if viewStore.isWeatherRequest {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .id(UUID())
                    }
                    
                    if let climate = viewStore.result {
                        Text(climate.weather[0].main)
                    }
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeatherView(store: Store(initialState: Weathers.State(), reducer: Weathers()))
        }
    }
}
