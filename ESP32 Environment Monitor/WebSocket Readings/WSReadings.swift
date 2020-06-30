//
//  WSReadings.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import Foundation



class WSReadings: ObservableObject, WSConnectionDelegate {
    var socket: WSNative?
    
    @Published var temperature: Float = 0.0;
    @Published var pressure: Float = 0.0;
    @Published var humidity: Float = 0.0;
    
    init() {
        socket = WSNative(url: URL(string: "ws://192.168.1.100:81")!, autoConnect: true)
        socket?.delegate = self
    }
    
    func onConnected(connection: WSConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WSConnection, error: Error?) {
        print("Disconnected")
    }
    
    func onError(connection: WSConnection, error: Error) {
        print("An error has occured")
    }
    
    func onMessage(connection: WSConnection, text: String) {
        // Check message conforms to get_all protocol
        if text.hasPrefix("A=") {
            parseGetAllString(text: text)
        } else {
            print("Non conforming string")
        }
    }
    
    func parseGetAllString(text: String) {
        DispatchQueue.main.async {
            let tempText = text.dropFirst(2)
            // Split array into components
            let recvTextArray = tempText.components(separatedBy: ",")
            // Set temp, pressure and humidity accordingly
            self.temperature = (recvTextArray[0] as NSString).floatValue
            self.pressure = (recvTextArray[1] as NSString).floatValue
            self.humidity = (recvTextArray[2] as NSString).floatValue
        }
    }
    
    
}
