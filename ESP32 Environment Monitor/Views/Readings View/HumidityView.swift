//
//  HumidityView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

extension Color {
    static let humidityTop = Color("humidityTop")
    static let humidityBottom = Color("humidityBottom")
}

struct HumidityView: View {
    @EnvironmentObject var wsReadings: WSReadings
    // Case statement
    let gradient = Gradient(colors: [.humidityTop, .humidityBottom])
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .frame(height: 100)
            HStack {
                VStack(alignment: .leading) {
                    Text("Humidity")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                    Text(String(wsReadings.humidity) + "%")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                }
                .padding()
                Spacer()
                Image(systemName: "cloud.rain")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                .padding()
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct HumidityView_Previews: PreviewProvider {
    static var previews: some View {
        HumidityView()
    }
}
