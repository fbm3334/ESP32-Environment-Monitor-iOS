//
//  ConnectionStatusView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 11/07/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

struct ConnectionStatusView: View {
    @EnvironmentObject var wsReadings: WSReadings
    
    @ViewBuilder
    var body: some View {
        if wsReadings.isConnected == true {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.green)
                Text("Connected to ESP32")
            }
        } else {
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.red)
                Text("Not connected to ESP32")
            }
        }
    }
}

struct ConnectionStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusView()
        .environmentObject(WSReadings())
    }
}
