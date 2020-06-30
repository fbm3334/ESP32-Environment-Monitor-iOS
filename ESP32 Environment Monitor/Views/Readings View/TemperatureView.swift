//
//  TemperatureView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

extension Color {
    static let temperatureTop = Color("temperatureTop")
    static let temperatureBottom = Color("temperatureBottom")
}

struct TemperatureView: View {
    @EnvironmentObject var wsReadings: WSReadings
    // Case statement
    let gradient = Gradient(colors: [.temperatureTop, .temperatureBottom])
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .frame(height: 100)
            HStack {
                VStack(alignment: .leading) {
                    Text("Temperature")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                    Text(String(wsReadings.temperature) + "ºC")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                }
                .padding()
                Spacer()
                Image(systemName: "thermometer")
                    .font(.system(size: 50))
                .foregroundColor(Color.white)
                .padding()
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct TemperatureView_Previews: PreviewProvider {
    //var temperatureInfo: ReadingInfo = ReadingInfo(type: .temperature)

    static var previews: some View {
        TemperatureView()
    }
}
