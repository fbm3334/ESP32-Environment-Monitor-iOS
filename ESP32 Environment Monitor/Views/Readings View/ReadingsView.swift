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
    
    // UserDefaults
    let defaults = UserDefaults.standard
    
    @ViewBuilder
    var body: some View {
        NavigationView {
                VStack {
                    
                    if defaults.bool(forKey: "serverInit") == true {
                        ScrollView {
                            ReadingsViewIndividual(readingType: .temperature)
                            ReadingsViewIndividual(readingType: .pressure)
                            ReadingsViewIndividual(readingType: .humidity)
                        }
                        .navigationBarTitle(Text("Readings"))
                        .navigationBarItems(leading: Button(action: {
                            // Only perform button actions if server initialised
                            if self.defaults.bool(forKey: "serverInit") == true {
                                self.wsReadings.socket.connect()
                                self.wsReadings.requestAllReadings()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 20))
                        })
                        // Time last refreshed
                        Text("LAST UPDATED: " + wsReadings.lastRefreshedString)
                            .foregroundColor(.gray)
                    } else {
                        VStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color.red)
                            Spacer()
                                .frame(height: 30)
                            Text("Configuration required")
                                .font(Font.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.red)
                            Spacer()
                            .frame(height: 30)
                            Text("The ESP32 environment monitor's IP address and port need to be configured - you can do this from the Setup tab at the bottom of the screen.")
                                .multilineTextAlignment(.center)
                        }
                    .padding()
                    }
                    Spacer()
                    ConnectionStatusView()
                    Spacer()
                        .frame(height: 5)
                }
                
            
        }
        
    }
}

struct ReadingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingsView()
    }
}
