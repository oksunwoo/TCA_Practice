//
//  Core.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/16.
//

import ComposableArchitecture

struct Root: ReducerProtocol {
    struct State: Equatable {
        var counter = Counter.State()
        var effectsCancellation = EffectsCancellation.State()
        var numberFact = NumberFact.State()
    }
    
    enum Action {
        case counter(Counter.Action)
        case effectsCancellation(EffectsCancellation.Action)
        case numberFact(NumberFact.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        
        Scope(state: \.counter, action: /Action.counter) {
            Counter()
        }
        
        Scope(state: \.effectsCancellation, action: /Action.effectsCancellation) {
            EffectsCancellation()
        }
        
        Scope(state: \.numberFact, action: /Action.numberFact) {
            NumberFact()
        }
    }
    
}
