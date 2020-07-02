//
//  ReadingsView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

enum ReadingType {
    case temperature
    case pressure
    case humidity
}

struct ReadingsView: View {
    @EnvironmentObject var wsReadings: WSReadings
    var readingType: ReadingType = .temperature
    
    var body: some View {
        NavigationView {
            
                VStack {
                    ReadingsViewIndividual(readingType: .temperature)
                    ReadingsViewIndividual(readingType: .pressure)
                    ReadingsViewIndividual(readingType: .humidity)
                    //PressureView()
                    //HumidityView()
                    
                    // Time last refreshed
                    Text("LAST UPDATED: " + wsReadings.lastRefreshedString)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .navigationBarTitle(Text("Readings"))
                .navigationBarItems(leading: Button(action: {
                self.wsReadings.socket.connect()
                self.wsReadings.requestAllReadings()
            }) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 20))
            })
            
        }
        
    }
}

struct ReadingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingsView()
    }
}
