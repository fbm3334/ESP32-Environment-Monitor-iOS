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
                        Text("Temperature")
                        Spacer()
                        Image(systemName: "thermometer")
                    }
                    NavigationLink(destination: PressureGraph().environmentObject(csvReadings)) {
                        Text("Pressure")
                        Spacer()
                        Image(systemName: "wind")
                    }
                    NavigationLink(destination: HumidityGraph().environmentObject(csvReadings)) {
                        Text("Humidity")
                        Spacer()
                        Image(systemName: "cloud.rain")
                    }
                    NavigationLink(destination: CSVView().environmentObject(csvReadings)) {
                        Text("View Stored Readings")
                        Spacer()
                        Image(systemName: "eyeglasses")
                        
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
            
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
        
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
