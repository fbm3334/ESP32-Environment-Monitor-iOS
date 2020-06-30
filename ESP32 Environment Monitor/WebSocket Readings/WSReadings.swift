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
    
    
}
