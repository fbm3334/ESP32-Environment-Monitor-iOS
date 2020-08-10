//
//  TemperatureGraph.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 10/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct TemperatureGraph: View {
    @EnvironmentObject var csvReadings: CSVReadings
    var body: some View {
        VStack {
            LineView(data: csvReadings.tempArray, title: "Temperature (ºC)", legend: "Last 30 readings")
                .padding()
            Spacer()
        }
    .navigationBarTitle("Temperature Graph")
    }
}

struct TemperatureGraph_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureGraph()
    }
}
