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
                    NavigationLink("NumberFact", destination: NumberFactView(store: self.store.scope(state: \.numberFact, action: Root.Action.numberFact)))
                    
                    NavigationLink("Cancellation",
                                   destination: EffectsCancellationView(store: self.store.scope(state: \.effectsCancellation, action: Root.Action.effectsCancellation)))
                    
                    NavigationLink("Weather",
                                   destination: WeatherView(store: self.store.scope(state: \.weather, action: Root.Action.weather)))
                    
                    NavigationLink("PhotoPass",
                                   destination: PhotoPassView(store: self.store.scope(state: \.photo, action: Root.Action.photo)))
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
