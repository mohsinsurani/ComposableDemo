//
//  ComposableDemoApp.swift
//  ComposableDemo
//
//  Created by Admin on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableDemoApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
       CounterFeature()
         ._printChanges()
     }
    var body: some Scene {
        WindowGroup<ContentView> {
            ContentView(store: ComposableDemoApp.store)
        }
    }
}
