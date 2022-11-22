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
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient
    private enum DelayID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.numberFact = nil
            
            return state.count >= 0 ? .none : .task {
                try await
                self.clock.sleep(for: .seconds(1))
                
                return .decrementDelayResponse
            }.cancellable(id: DelayID.self)
            
        case .decrementDelayResponse:
            if state.count < 0 {
                state.count += 1
            }
            
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            state.numberFact = nil
            
            return state.count >= 0 ? .cancel(id: DelayID.self) : .none
            
        case .numberFactButtonTapped:
            state.isNumberFactRequestInFlight = true
            state.numberFact = nil
            
            return .task {
                [count = state.count] in
                await .numberFactResponse(TaskResult {
                    try await
                    self.factClient.fetch(count)
                })
            }
            
        case .numberFactResponse(.success(let response)):
            state.isNumberFactRequestInFlight = false
            state.numberFact = response
            
            return .none
        
        case .numberFactResponse(.failure):
            state.isNumberFactRequestInFlight = false
            
            return .none
        }
    }
}

struct NumberFactView: View {
    let store: StoreOf<NumberFact>
    @Environment(\.openURL) var openURL
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    HStack {
                        Button {
                            viewStore.send(.decrementButtonTapped)
                        } label: {
                            Image(systemName: "minus")
                        }
                        
                        Text("\(viewStore.count)")
                            .monospacedDigit()
                        
                        Button {
                            viewStore.send(.incrementButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button("NumberFact") {
                        viewStore.send(.numberFactButtonTapped)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct NumberFactView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFactView(store: Store(initialState: NumberFact.State(), reducer: NumberFact()))
    }
}
