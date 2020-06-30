//
//  PressureView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI

extension Color {
    static let pressureTop = Color("pressureTop")
    static let pressureBottom = Color("pressureBottom")
}

struct PressureView: View {
    @EnvironmentObject var wsReadings: WSReadings
    // Case statement
    let gradient = Gradient(colors: [.pressureTop, .pressureBottom])
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .frame(height: 100)
            HStack {
                VStack(alignment: .leading) {
                    Text("Pressure")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                    Text(String(wsReadings.pressure) + "mb")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                }
                .padding()
                Spacer()
                Image(systemName: "hurricane")
                    .font(.system(size: 50))
                .foregroundColor(Color.white)
                .padding()
            }
            
        }
    .padding(.horizontal)
    .padding(.bottom)
    }
}

struct PressureView_Previews: PreviewProvider {
    static var previews: some View {
        PressureView()
    }
}
