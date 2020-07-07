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
    // Timer to refresh readings
    var refreshTimer: Timer?
    
    // UserDefaults
    let defaults = UserDefaults.standard
    
    var socket: WebSocket!
    var isConnected: Bool = false
    
    @Published var temperature: Float = 0.0;
    @Published var pressure: Float = 0.0;
    @Published var humidity: Float = 0.0;
    var lastRefreshed: Date = Date()
    @Published var lastRefreshedString: String = ""
    @Published public var refreshInterval: Int
    @Published var refreshIntervalString: String = ""
    
    
    init() {
        let url = URL(string: "ws://192.168.1.100:81")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        self.refreshInterval = 10
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
            print("Error: \(error!)")
            
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func requestAllReadings() {
        print("Requesting...")
        socket.write(string: "get_all")
        lastRefreshed = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy H:mm:ss"
        lastRefreshedString = formatter.string(from: lastRefreshed)
        
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
    
    func changeRefreshInterval(interval: Int) {
        refreshTimer?.invalidate()
        print("Timer invalidated!")
        refreshInterval = interval
        refreshTimer = Timer.scheduledTimer(timeInterval: Double(refreshInterval), target: self, selector: #selector(refreshReadingsTimed), userInfo: nil, repeats: true)
        print("Interval changed: \(refreshInterval)")
        defaults.set(refreshInterval, forKey: "refresh_interval")
    }
    
    func setupTimer() {
        refreshInterval = defaults.integer(forKey: "refresh_interval")
        print("Recovered value = \(refreshInterval)")
        // Default to 10 if interval is zero
        if refreshInterval == 0 {
            refreshInterval = 10
        }
        refreshIntervalString = String(refreshInterval)
        refreshTimer = Timer.scheduledTimer(timeInterval: Double(refreshInterval), target: self, selector: #selector(refreshReadingsTimed), userInfo: nil, repeats: true)
    }
    
    @objc func refreshReadingsTimed() {
        socket.connect()
        requestAllReadings()
    }
    
    func invalidateTimer() {
        refreshTimer?.invalidate()
    }
}
