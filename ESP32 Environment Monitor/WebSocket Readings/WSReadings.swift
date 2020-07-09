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
    @Published public var refreshInterval: Int = 0
    @Published var refreshIntervalString: String = ""
    
    
    init() {
        if defaults.bool(forKey: "serverInit") == false {
            print("WS not initialised")
        } else {
            initWebSocket()
        }
    }
    
    func initWebSocket() {
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
            print("Error: \(error!)")
            // Set the server initialisation flag to false - may need to reinitialise the server
            defaults.set(false, forKey: "serverInit")
            
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func requestAllReadings() {
        // Only request if server has been defined properly
        if defaults.bool(forKey: "serverInit") == true {
            print("Requesting...")
            socket.write(string: "get_all")
            lastRefreshed = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy H:mm:ss"
            lastRefreshedString = formatter.string(from: lastRefreshed)
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
    
    func changeRefreshInterval(interval: Int) {
        // Set refresh interval to given interval
        refreshInterval = interval
        // Save the nwt
        defaults.set(refreshInterval, forKey: "refreshInterval")
        // Use setupTimer function to set up the timer based on the new value
        setupTimer()
    }
    
    func setupTimer() {
        // Invalidate timer just in case
        invalidateTimer()
        // Get the refresh interval from UserDefaults
        refreshInterval = defaults.integer(forKey: "refreshInterval")
        print("Recovered interval value = \(refreshInterval)")
        // Set interval to default of 10 if retrieved value is 0
        if refreshInterval == 0 {
            refreshInterval = 10
        }
        refreshIntervalString = String(refreshInterval) // Save refresh interval as string
        // Set up refresh timer with correct values
        refreshTimer = Timer.scheduledTimer(timeInterval: Double(refreshInterval), target: self, selector: #selector(refreshReadingsTimed), userInfo: nil, repeats: true)
    }
    
    // Function to refresh timings
    @objc func refreshReadingsTimed() {
        // Connect to the ESP32 WebSocket server
        socket.connect()
        // Request the readings
        requestAllReadings()
    }
    
    func invalidateTimer() {
        // Invalidate the timer and print to console
        refreshTimer?.invalidate()
        print("Timer invalidated!")
    }
}
