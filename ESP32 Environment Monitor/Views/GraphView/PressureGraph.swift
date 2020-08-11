//
//  PressureGraph.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 10/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct PressureGraph: View {
    @EnvironmentObject var csvReadings: CSVReadings
    var body: some View {
        VStack {
            LineView(data: csvReadings.pressureArray, title: "Pressure (mb)", legend: "Last 30 readings")
                .padding()
            Spacer()
                .frame(height: 50)
            HStack {
                Text(csvReadings.earliestDate)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                Spacer()
                Text(csvReadings.latestDate)
                    .multilineTextAlignment(.trailing)
                    .font(.caption)
            }
            .padding()
            Spacer()
        }
            .offset(x: 0, y: -20)
    .navigationBarTitle("Pressure Graph")
    }
}

struct PressureGraph_Previews: PreviewProvider {
    static var previews: some View {
        PressureGraph()
    }
}
