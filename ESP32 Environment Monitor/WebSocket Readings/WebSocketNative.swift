//
//  WebSocketNative.swift
//  ESP32 Environment Monitor
//
//  Created by Finn Beckitt-Marshall on 30/06/2020.
//  Copyright © 2020 Finn Beckitt-Marshall. All rights reserved.
//

import Foundation

// Defining protocols for WebSocket
protocol WSConnection {
    func connect()
    func send(text: String)
    func send(data: Data)
    func listen()
    func ping(with: TimeInterval)
    func disconnect()
    var delegate: WSConnectionDelegate? {get set}
}

protocol WSConnectionDelegate: class {
    func onConnected(connection: WSConnection)
    func onDisconnected(connection: WSConnection, error: Error?)
    func onError(connection: WSConnection, error: Error)
    func onMessage(connection: WSConnection, text: String)
    func onMessage(connection: WSConnection, data: Data)
}

extension WSConnectionDelegate {
    func onMessage(connection: WSConnection, text: String) {}
    func onMessage(connection: WSConnection, data: Data) {}
}

class WSNative: NSObject, WSConnection, URLSessionWebSocketDelegate {
    weak var delegate: WSConnectionDelegate?
    var wsTask: URLSessionWebSocketTask!
    var urlSession: URLSession!
    let delegateQueue = OperationQueue()
    private var pingTimer: Timer?
    
    init(url: URL, autoConnect: Bool = false) {
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        wsTask = urlSession.webSocketTask(with: url)
        if autoConnect {
            connect()
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.onConnected(connection: self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        delegate?.onDisconnected(connection: self, error: nil)
    }
    
    func connect() {
        wsTask.resume()
        listen()
    }
    
    func send(text: String) {
        let textMessage = URLSessionWebSocketTask.Message.string(text)
        wsTask.send(textMessage) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
    
    func send(data: Data) {
        let dataMessage = URLSessionWebSocketTask.Message.data(data)
        wsTask.send(dataMessage) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }

    func listen()  {
        wsTask.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.onMessage(connection: self, text: text)
                case .data(let data):
                    self.delegate?.onMessage(connection: self, data: data)
                @unknown default:
                    fatalError()
                }
            }
            self.listen()
        }
    }
    
    func ping(with frequency: TimeInterval = 25.0) {
        pingTimer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.wsTask.sendPing { error in
                if let error = error {
                    self.delegate?.onError(connection: self, error: error)
                }
            }
        }
    }
    
    func disconnect() {
        wsTask.cancel(with: .normalClosure, reason: nil)
        pingTimer?.invalidate()
    }
}
