//
//  ReadingsViewIndividual.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

struct ReadingsViewIndividual: View {
    @EnvironmentObject var wsReadings: WSReadings
    let readingType: ReadingType
    
    @ViewBuilder
    var body: some View {
        ZStack {
            if (readingType == .temperature) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: 100)
                .foregroundColor(.red)
            } else if (readingType == .pressure) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: 100)
                    .foregroundColor(.purple)
            } else if (readingType == .humidity) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: 100)
                .foregroundColor(.blue)
            }
            HStack {
                VStack(alignment: .leading) {
                    if (readingType == .temperature) {
                        Text("Temperature")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                        // If the temperature is in Fahrenheit, show ºF
                        if (wsReadings.tempFahrenheit == true) {
                            Text(String(format: "%.1fºF", wsReadings.temperature))
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                        } else {
                            Text(String(format: "%.1fºC", wsReadings.temperature))
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                        }
                        
                    } else if (readingType == .pressure) {
                        Text("Pressure")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                        Text(String(wsReadings.pressure) + "mb")
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                    } else if (readingType == .humidity) {
                        Text("Humidity")
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                        Text(String(wsReadings.humidity) + "%")
                            .foregroundColor(Color.white)
                            .font(.system(size: 30))
                    }
                    
                }
                .padding()
                Spacer()
                if (readingType == .temperature) {
                    Image(systemName: "thermometer")
                        .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .padding()
                } else if (readingType == .pressure) {
                    Image(systemName: "wind")
                        .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .padding()
                } else if (readingType == .humidity) {
                    Image(systemName: "cloud.rain")
                        .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .padding()
                }
                
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct ReadingsViewIndividual_Previews: PreviewProvider {
    //var temperatureInfo: ReadingInfo = ReadingInfo(type: .temperature)

    static var previews: some View {
        ReadingsViewIndividual(readingType: .temperature)
    }
}
