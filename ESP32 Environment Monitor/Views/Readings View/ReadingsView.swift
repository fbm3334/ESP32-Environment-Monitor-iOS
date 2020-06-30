//
//  ReadingsView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

struct ReadingsView: View {
    @EnvironmentObject var wsReadings: WSReadings
       
    var body: some View {
        VStack {
            TemperatureView()
            PressureView()
            HumidityView()
            Button(action: {
                self.wsReadings.socket?.send(text: "get_all")
                //self.wsReadings.socket?.listen()
            }) {
                Text("Get Readings")
            }
        }
    }
}

struct ReadingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingsView()
    }
}
