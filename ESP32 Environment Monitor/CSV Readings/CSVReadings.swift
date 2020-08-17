//
//  CSVReadings.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 04/08/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import Foundation

struct CSVElements: Identifiable {
    var id: UUID
    var timestamp: Date
    var timeFormatted: String
    var temperature: Float
    var pressure: Float
    var humidity: Float
}

class CSVReadings: ObservableObject {
    // UserDefaults
    let defaults = UserDefaults.standard
    
    let wsReadings = WSReadings()
    
    // URL for the connection
    var url: String = ""
    // CSV text
    var csvText: String?
    @Published var downloadedCSV: Bool = false
    
    var lineTemp: [String] = [""]
    var elementsTemp = CSVElements(id: UUID(), timestamp: Date(timeIntervalSince1970: 0), timeFormatted: "", temperature: 0.0, pressure: 0.0, humidity: 0.0)
    var elementsArray: [CSVElements] = []
    var tempArray: [Double] = []
    var pressureArray: [Double] = []
    var humidityArray: [Double] = []
    
    @Published var earliestDate: String = ""
    @Published var latestDate: String = ""
    
    @Published var tempFahrenheit: Bool = false
    
    @Published var chartTitle: String = ""
    
    init() {
        if defaults.bool(forKey: "serverInit") == false {
            print("URL not initialised")
        } else {
            setDownloadURLfromUD()
        }
    }
    
    // Function to set the CSV download URL
    func setCSVDownloadURL(ipAddress: String) {
        // Set the download URL - of the form http://ip_address/download
        // IP address is prevalidated in SetupView
        url = "http://" + String(ipAddress) + "/download"
        print(url)
    }
    
    // Function to set the CSV download URL from UserDefaults saved address
    func setDownloadURLfromUD() {
        // Get the download URL from UserDefaults
        let defaultsURL = defaults.url(forKey: "URL")
        print("Defaults URL = \(defaultsURL!)")
        var defaultsURLString = "\(defaultsURL!)"
        // Remove the first 5 characters
        defaultsURLString.removeFirst(5)
        // Remove everything past the port colon (including the colon)
        if let portRange = defaultsURLString.range(of: ":") {
            defaultsURLString.removeSubrange(portRange.lowerBound..<defaultsURLString.endIndex)
        }
        print("URL String = \(defaultsURLString)")
        setCSVDownloadURL(ipAddress: defaultsURLString)
    }
    
    // Function to download the CSV file
    func downloadCSV() {
        let task = URLSession.shared.downloadTask(with: URL(string: url)!) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    //print(string)
                    self.csvText = string
                }
            }
        }
        
        task.resume() // Resume the download
        while csvText == nil {
            // Execute while the string is empty
        }
        //downloadedCSV = true
        print(csvText!)
        separateCSVIntoElements()
    }
    
    // Function to add CSV data into arrays
    func addCSV(elementsTemp: CSVElements) {
        elementsArray.append(elementsTemp)
        tempArray.append(Double(elementsTemp.temperature))
        pressureArray.append(Double(elementsTemp.pressure))
        humidityArray.append(Double(elementsTemp.humidity))
    }
    
    // Function to seperate the CSV file into individual elements
    func separateCSVIntoElements() {
        var cleanCSV = csvText?.replacingOccurrences(of: "\r", with: "\n")
        cleanCSV = cleanCSV?.replacingOccurrences(of: "\n\n", with: "\n")
        var csvLines = cleanCSV?.components(separatedBy: ["\n"])
        // Remove the last element
        csvLines?.removeLast()
        for line in csvLines! {
            lineTemp = line.components(separatedBy: [","])
            let unixTimeDouble = Double(lineTemp[0]) ?? 0
            elementsTemp.id = UUID()
            elementsTemp.timestamp = Date(timeIntervalSince1970: unixTimeDouble)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy HH:mm:ss"
            elementsTemp.timeFormatted = formatter.string(from: elementsTemp.timestamp)
            if (tempFahrenheit == true) {
                elementsTemp.temperature = wsReadings.convertToFahrenheit(celsius: Float(lineTemp[1])!)
                print(elementsTemp.temperature)
            } else {
                elementsTemp.temperature = Float(lineTemp[1])!
            }
            elementsTemp.pressure = Float(lineTemp[2])!
            elementsTemp.humidity = Float(lineTemp[3])!
            // Append this to the main vector
            addCSV(elementsTemp: elementsTemp)
        }
        // Print the array
        print("-------- ARRAY ---------")
        print(tempArray)
        // Remove all but the last 30 values - this wil be when elementsArray is < 30
        if (elementsArray.count > 30) {
            tempArray.removeFirst(tempArray.count - 30)
            pressureArray.removeFirst(pressureArray.count - 30)
            humidityArray.removeFirst(humidityArray.count - 30)
            latestDate = elementsArray[elementsArray.count - 1].timeFormatted
            earliestDate = elementsArray[elementsArray.count - 31].timeFormatted
        }
        if (tempArray.count > 30) {  }
        if (pressureArray.count > 30) { pressureArray.removeFirst(pressureArray.count - 30) }
        if (humidityArray.count > 30) { humidityArray.removeFirst(humidityArray.count - 30) }
        print(tempArray)
        setChartTitle()
        downloadedCSV = true
    }
    
    // Function to set the appropriate chart title
    func setChartTitle() {
        if (tempFahrenheit == true) {
            chartTitle = "Temperature (ºF)"
        } else {
            chartTitle = "Temperature (ºC)"
        }
    }
    
    // Function to clear the arrays
    func clearArrays() {
        elementsArray.removeAll()
        tempArray.removeAll()
        pressureArray.removeAll()
        humidityArray.removeAll()
    }
}
