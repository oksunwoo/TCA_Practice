//
//  EffectsCancellation.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/16.
//
import ComposableArchitecture
import SwiftUI

struct EffectsCancellation: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var currentFact: String?
        var isFactRequestInFlight = false
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case stepperChanged(Int)
        case factButtonTapped
        case factResponse(TaskResult<String>)
    }
    
    //@Dependency(\.fac)
}

struct EffectsCancellationView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EffectsCancellation_Previews: PreviewProvider {
    static var previews: some View {
        EffectsCancellationView()
    }
}
