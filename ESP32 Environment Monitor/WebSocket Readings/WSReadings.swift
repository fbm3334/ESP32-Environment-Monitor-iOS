//
//  WSReadings.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import Foundation
import Starscream

class WSReadings: ObservableObject, WebSocketDelegate {
    
    var socket: WebSocket!
    var isConnected: Bool = false
    
    @Published var temperature: Float = 0.0;
    @Published var pressure: Float = 0.0;
    @Published var humidity: Float = 0.0;
    
    init() {
        let url = URL(string: "ws://192.168.1.100:81")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            if string.hasPrefix("A=") {
                parseGetAllString(text: string)
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print("Error: \(error)")
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func requestAllReadings() {
        socket.write(string: "get_all")
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
