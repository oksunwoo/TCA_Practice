//
//  NumberFactView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/17.
//

import SwiftUI
import ComposableArchitecture

struct NumberFact: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case decrementDelayResponse
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(TaskResult<String>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        <#code#>
    }
}

struct NumberFactView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NumberFactView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFactView()
    }
}
