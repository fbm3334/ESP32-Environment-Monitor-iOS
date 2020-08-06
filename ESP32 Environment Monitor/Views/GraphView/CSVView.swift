//
//  CSVView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 06/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI



struct CSVView: View {
    @EnvironmentObject var csvReadings: CSVReadings
    var body: some View {
        NavigationView {
            return List(self.csvReadings.elementsArray) { csvRow in
                CSVRow(csvRow: csvRow)
            }
        //.navigationBarTitle("View Stored Readings")
        }
    }
}

struct CSVRow: View {
    @EnvironmentObject var csvReadings: CSVReadings
    
    var csvRow: CSVElements
    
    var body: some View {
        VStack {
            Text("\(csvRow.timeFormatted)")
            HStack {
                VStack {
                    Text("Temperature")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Pressure")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Text("Humidity")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                VStack {
                    Text("\(csvRow.temperature)°C")
                        .multilineTextAlignment(.trailing)
                    Text("\(csvRow.pressure) mb")
                        .multilineTextAlignment(.trailing)
                    Text("\(csvRow.humidity)%")
                        .multilineTextAlignment(.trailing)
                }
                
            }
            
        }
    }
}

struct CSVView_Previews: PreviewProvider {
    static var previews: some View {
        CSVView()
    }
}
