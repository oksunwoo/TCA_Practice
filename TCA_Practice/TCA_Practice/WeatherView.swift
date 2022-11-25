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
        
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        <#code#>
    }
}


struct WeatherView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
