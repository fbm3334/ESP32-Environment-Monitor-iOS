//
//  GraphView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 06/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI
import SwiftUICharts


struct GraphView: View {
    let defaults = UserDefaults.standard
    @EnvironmentObject var csvReadings: CSVReadings
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            // If CSV dagta downloaded, show views, else show error
            if (csvReadings.downloadedCSV == true) {
                List {
                    NavigationLink(destination: TemperatureGraph().environmentObject(csvReadings)) {
                        Image(systemName: "thermometer")
                        Text("Temperature")
                    }
                    NavigationLink(destination: PressureGraph().environmentObject(csvReadings)) {
                        Image(systemName: "wind")
                        Text("Pressure")
                    }
                    NavigationLink(destination: HumidityGraph().environmentObject(csvReadings)) {
                        Image(systemName: "cloud.rain")
                        Text("Humidity")
                    }
                    NavigationLink(destination: CSVView().environmentObject(csvReadings)) {
                        Text("View Stored Readings")
                    }
                    
                }
                .navigationBarTitle("Graphs")
                .navigationBarItems(leading: Button(action: {
                    // Only perform button actions if server initialised
                    if self.defaults.bool(forKey: "serverInit") == true {
                        self.csvReadings.downloadCSV()
                    }
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 20))
                })
            } else {
                VStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.red)
                        Spacer()
                            .frame(height: 30)
                        Text("No data available")
                            .font(Font.largeTitle.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.red)
                        Spacer()
                        .frame(height: 30)
                        Text("No data has been downloaded from the ESP32 - press the Refresh button below to download data.")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            // Only perform button actions if server initialised
                            if self.defaults.bool(forKey: "serverInit") == true {
                                self.csvReadings.downloadCSV()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 20))
                        }
                    }
                .padding()
            }
            
        }
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
