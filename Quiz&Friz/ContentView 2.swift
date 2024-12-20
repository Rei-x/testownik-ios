//
//  ContentView 2.swift
//  Quiz&Friz
//
//  Created by stud on 05/11/2024.
//


import SwiftUI

struct ContentView2: View {
    @State private var isDetailViewPresented = false

    var body: some View {
        VStack {
            Text("Home View")
                .font(.largeTitle)
                .padding()
            
            Button("Go to Detail View") {
                withAnimation {
                    isDetailViewPresented.toggle()
                }
            }
            .padding()

            if isDetailViewPresented {
                DetailView5(isPresented: $isDetailViewPresented)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
    }
}

struct DetailView5: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Detail View")
                .font(.largeTitle)
                .padding()

            Button("Go Back") {
                withAnimation {
                    isPresented.toggle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView2()
}
