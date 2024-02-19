//
//  ContentView.swift
//  SwiftBlrTCADemo
//
//  Created by Mohsin on 18/02/24.
//

// ContentView.swift

import SwiftUI
import ComposableArchitecture

// Define the main view structure
struct ContentView: View {
    
    // Declare a store property of type `StoreOf<CounterFeature>`
    let store: StoreOf<CounterFeature>
    
    // Define the body of the view
    var body: some View {
        
        // Use WithViewStore to interact with the view's associated store
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            // Main VStack containing various UI components
            
            VStack {
                
                // Display the current count from the store's state
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                
                // HStack containing buttons for increment and decrement actions
                
                HStack {
                    Button("-") {
                        // Send the decrement action to the store when the "-" button is tapped
                        store.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        // Send the increment action to the store when the "+" button is tapped
                        store.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Button for toggling the timer
                
                Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
                    // Send the toggle timer action to the store when the timer button is tapped
                    store.send(.toggleTimerButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                // Button for fetching a "fact"
                
                Button("Fact") {
                    // Send the fact button action to the store when the fact button is tapped
                    store.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Display a loading indicator if the viewStore indicates that it's loading
            if viewStore.isLoading {
                ProgressView()
            }
            // If there is a fact available, display it
            else if let fact = viewStore.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

// PreviewProvider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        })
    }
}
