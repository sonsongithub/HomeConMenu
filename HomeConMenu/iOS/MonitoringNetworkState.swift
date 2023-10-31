//
//  MonitoringNetworkState.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2023/10/15.
//

import Foundation
import Network

class MonitoringNetworkState: ObservableObject {
    
    static let didPathUpdateNotification = Notification.Name("didPathUpdateNotification")
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            NotificationCenter.default.post(name: MonitoringNetworkState.didPathUpdateNotification, object: path)
        }
    }
}
