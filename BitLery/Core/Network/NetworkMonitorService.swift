//
//  NetworkMonitorService.swift
//  BitLery
//
//  Created by 정인선 on 3/11/25.
//

import Foundation
import Network

final class NetworkMonitorService {
    static let shared = NetworkMonitorService()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitor() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            isConnected = path.status == .satisfied
        }
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
}
