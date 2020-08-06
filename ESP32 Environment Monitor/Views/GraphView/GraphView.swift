//
//  GraphView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 06/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI



struct GraphView: View {
    @EnvironmentObject var csvReadings: CSVReadings
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: CSVView().environmentObject(csvReadings)) {
                Text("View CSV")
            }

            .navigationBarTitle("Graph")
            .navigationBarItems(leading: Button(action: {
                // Only perform button actions if server initialised
                if self.defaults.bool(forKey: "serverInit") == true {
                    self.csvReadings.downloadCSV()
                }
            }) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 20))
            })
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
