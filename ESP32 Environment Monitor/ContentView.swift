//
//  ContentView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var wsReadings: WSReadings
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            ReadingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "thermometer")
                        Text("Readings")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar")
                        Text("Graph")
                    }
                }
                .tag(1)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Setup")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(WSReadings())
    }
}
