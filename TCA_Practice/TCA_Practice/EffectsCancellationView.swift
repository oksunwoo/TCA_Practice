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
    
    @Dependency(\.factClient) var factClient
    private enum NumberFactRequestID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cancelButtonTapped:
            state.isFactRequestInFlight = false
            return .cancel(id: NumberFactRequestID.self)
            
        case .stepperChanged(let value):
            state.count = value
            state.currentFact = nil
            state.isFactRequestInFlight = false
            return .cancel(id: NumberFactRequestID.self)
            
        case .factButtonTapped:
            state.currentFact = nil
            state.isFactRequestInFlight = true
            
            return .task { [count = state.count] in
                await .factResponse(TaskResult { try await
                    self.factClient.fetch(count) })
            }
            .cancellable(id: NumberFactRequestID.self)
            
        case .factResponse(.success(let response)):
            state.isFactRequestInFlight = false
            state.currentFact = response
            return .none
            
        case .factResponse(.failure):
            state.isFactRequestInFlight = false
            return .none
        }
    }
}

struct EffectsCancellationView: View {
    let store: StoreOf<EffectsCancellation>
    @Environment(\.openURL) var openURL
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Stepper("\(viewStore.count)",
                            value: viewStore.binding(get: \.count, send: EffectsCancellation.Action.stepperChanged)
                    )
                    
                    if viewStore.isFactRequestInFlight {
                        HStack {
                            Button("Cancel") {
                                viewStore.send(.cancelButtonTapped)
                            }
                            Spacer()
                            ProgressView()
                                .id(UUID())
                        }
                    } else {
                        Button("Number fact") {
                            viewStore.send(.factButtonTapped)
                        }
                        .disabled(viewStore.isFactRequestInFlight)
                    }
                    
                    viewStore.currentFact.map {
                        Text($0).padding(.vertical, 8)
                    }
                }
                Section {
                    Button("Number facts provided by numbersapi.com") {
                        self.openURL(URL(string: "http://numbersapi.com")!)
                    }
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderless)
        }
        .navigationTitle("Effect Cancellation")
    }
}

struct EffectsCancellation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            EffectsCancellationView(store: Store(initialState: EffectsCancellation.State(), reducer: EffectsCancellation()))
        }
    }
}
