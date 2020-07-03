//
//  SetupView.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 02/07/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import SwiftUI
import Combine

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct SetupView: View {
    @EnvironmentObject var wsReadings: WSReadings
    @State var refreshIntervalString: String = "10"
    //@State var refreshIntervalTemp: Int = 10
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Auto-refresh interval")) {
                    HStack {
                        Text("Interval (seconds)")
                        Spacer()
                        TextField("Interval", text: $refreshIntervalString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onReceive(Just(refreshIntervalString)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.refreshIntervalString = filtered
                                }
                            }
                                               
                    }
                    Button(action: {
                        self.wsReadings.changeRefreshInterval(interval: Int(self.refreshIntervalString)!)
                        print(self.wsReadings.refreshInterval)
                        self.hideKeyboard()
                        self.showingAlert = true
                    }) {
                        Text("Change interval")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Apply interval change"), message: Text("You will need to exit the app and reopen it to apply the time interval change."), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .navigationBarTitle("Setup")
            .listStyle(GroupedListStyle())
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
