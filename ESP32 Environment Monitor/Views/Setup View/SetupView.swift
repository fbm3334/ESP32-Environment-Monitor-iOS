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
    let defaults = UserDefaults.standard
    
    @EnvironmentObject var wsReadings: WSReadings
    @EnvironmentObject var csvReadings: CSVReadings
    @State var refreshIntervalString: String = ""
    @State var ipAddressString: String = ""
    @State var portString: String = ""
    @State var sdLogIntervalString: String = ""
    
    @State private var showIPPortValidationAlert = false
    @State private var showReadingIntervalValidationAlert = false
    
    // Modify multiple variables when Fahrenheit switch toggled
    @State private var fahrenheitToggleValue: Bool = false
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Configure server settings")) {
                    HStack {
                        Text("IP address:")
                        Spacer()
                        //refreshIntervalString = String(wsReadings.refreshInterval)
                        TextField("IP address", text: $ipAddressString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            // Regex to filter string
                            .onReceive(Just(ipAddressString)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    self.ipAddressString = filtered
                                }
                            }
                    }
                    HStack {
                        Text("Port:")
                        Spacer()
                        //refreshIntervalString = String(wsReadings.refreshInterval)
                        TextField("Port", text: $portString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            // Regex to filter string
                            .onReceive(Just(portString)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.portString = filtered
                                }
                            }
                    }
                    Button(action: {
                        // Validate the IP address when button pressed
                        if self.wsReadings.validateIPPort(ipAddress: self.ipAddressString, port: self.portString) == true {
                            // Configure the WebSocket with the correct IP
                            self.wsReadings.configWebSocket(ipString: self.ipAddressString, portString: self.portString)
                            self.wsReadings.repeatRequest()
                            // Configure the CSV download URL
                            self.csvReadings.setCSVDownloadURL(ipAddress: self.ipAddressString)
                        } else {
                            self.showIPPortValidationAlert = true
                        }
                        self.hideKeyboard()
                        
                    }) {
                        Text("Change IP address and port")
                    }
                    .alert(isPresented: $showIPPortValidationAlert) {
                        Alert(title: Text("IP address and/or port not valid"), message: Text("The IP address and/or port are not valid. Please check them and try again."), dismissButton: .default(Text("OK")))
                    }
                }
                
                Section(header: Text("Auto-refresh interval")) {
                    HStack {
                        Text("Interval (seconds)")
                        Spacer()
                        //refreshIntervalString = String(wsReadings.refreshInterval)
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
                    Text("Current interval: \(wsReadings.refreshInterval)")
                    Button(action: {
                        if self.refreshIntervalString.count != 0 {
                            self.wsReadings.changeRefreshInterval(interval: Int(self.refreshIntervalString)!)
                            print(self.wsReadings.refreshInterval)
                        }
                        self.hideKeyboard()
                        
                    }) {
                        Text("Change interval")
                    }
                }
                
                Section(header: Text("SD card logging interval")) {
                    HStack {
                        Text("Logging interval")
                        Spacer()
                        TextField("Interval", text: $sdLogIntervalString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onReceive(Just(sdLogIntervalString)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.sdLogIntervalString = filtered
                                }
                            }
                    }
                    Button(action: {
                        if self.wsReadings.changeSDLogInterval(intervalString: self.sdLogIntervalString) == true {
                            print("Change successful")
                        } else {
                            self.showReadingIntervalValidationAlert = true
                        }
                    }) {
                        Text("Change interval")
                    }
                    .alert(isPresented: $showReadingIntervalValidationAlert) {
                        Alert(title: Text("Reading interval not valid"), message: Text("The reading interval must be between 1 and 65,535 seconds. Please check it and try again."), dismissButton: .default(Text("OK")))
                    }
                }
                
                Section(header: Text("Units")) {
                    HStack {
                        Text("Temperature in Fahrenheit (ºF)")
                        Spacer()
                        Toggle("", isOn: $fahrenheitToggleValue)
                        .labelsHidden()
                            .onTapGesture {
                                self.fahrenheitToggleValue = !self.fahrenheitToggleValue
                                print("Toggle value")
                                self.wsReadings.tempFahrenheit = self.fahrenheitToggleValue
                                self.csvReadings.tempFahrenheit = self.fahrenheitToggleValue
                                print("Value = \(self.wsReadings.tempFahrenheit), CSV = \(self.csvReadings.tempFahrenheit)")
                            }
                           
                        }
                    }
                
                
            }
            .navigationBarTitle("Setup")
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
