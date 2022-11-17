//
//  RootView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/14.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Getting started")) {
                    NavigationLink("Counter",
                                   destination: CounterDemoView(store: self.store.scope(state: \.counter, action: Root.Action.counter)))
                }
                
                Section(header: Text("Effects")) {
                    NavigationLink("Cancellation",
                                   destination: EffectsCancellationView(store: self.store.scope(state: \.effectsCancellation, action: Root.Action.effectsCancellation))
                    )
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: Root.State(), reducer: Root()))
    }
}
