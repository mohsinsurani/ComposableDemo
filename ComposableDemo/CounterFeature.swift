// CounterFeature.swift

import ComposableArchitecture
import Combine
import Foundation
import SwiftUI

// Define the CounterFeature as a Reducer
struct CounterFeature: Reducer {
    
    // Define the state of the CounterFeature
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    // Define the actions that can be performed in the CounterFeature
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case timerTick
        case toggleTimerButtonTapped
    }
    
    // Enum to represent the cancellation ID for the timer
    enum CancelID { case timer }
    
    // The main body of the reducer
    var body: some ReducerOf<Self> {
        
        // Define the behavior for each action
        Reduce { state, action in
            switch action {
                
            // Decrement button tapped action
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            // Increment button tapped action
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            // Fact button tapped action
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                // Run an asynchronous task to fetch a fact from a numbers API
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
                
            // Timer tick action
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
                
            // Toggle timer button tapped action
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                
                // If the timer is running, start a recurring timer task
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    // If the timer is not running, cancel the existing timer task
                    return .cancel(id: CancelID.timer)
                }
                
            // Fact response action
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
            }
        }
    }
}
