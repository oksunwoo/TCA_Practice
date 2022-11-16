//
//  TCA_PracticeApp.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/11/14.
//
import ComposableArchitecture
import SwiftUI

@main
struct TCA_PracticeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: Root.State(), reducer: Root()
                .signpost()
                ._printChanges()
                )
            )
        }
    }
}
