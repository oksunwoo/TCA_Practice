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
        var latitude: Double = 0
        var longitude: Double = 0
        var isWeatherRequest = false
        var result: WeatherInformation?
    }
    
    enum Action: Equatable {
        case confirmButtonTapped
        case weatherResponse(TaskResult<WeatherInformation>)
    }
    
    @Dependency(\.weatherClient) var weatherClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .confirmButtonTapped:
            state.isWeatherRequest = true
            state.result = nil
            
            return .task { [latitude = state.latitude, longitude = state.longitude] in
                await .weatherResponse(TaskResult { try await
                    self.weatherClient.fetch(latitude, longitude)!
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
    let store: StoreOf<Weathers>
    @State var longitude: String = ""
    @State var latitude: String = ""
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    HStack {
                        VStack {
                            TextField("Enter longitude", text: $longitude)
                            TextField("Enter latitude", text: $latitude)
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        Button {
                            viewStore.send(.confirmButtonTapped)
                        } label: {
                            Text("Confirm")
                        }
                        .buttonStyle(.bordered)
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
