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
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(store: Store(initialState: Root.State(), reducer: Root()))
    }
}
