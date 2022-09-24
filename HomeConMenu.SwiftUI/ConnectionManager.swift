//
//  ConnectionManager.swift
//  HomeConMenu.SwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/24.
//

import Foundation


class ConnectionManager: NSObject, ObservableObject, ClientProtocol
  {

    private var _connection: NSXPCConnection!

    // Since the count is being displayed in the ContentView, it must be a Published variable
    @Published var count : Int = 0


    private func establishConnection() -> Void
      {
        // Create an XPC connection to the XPC service
        _connection = NSXPCConnection(serviceName: xpcServiceLabel)

        // Set the XPC interface of the connection's remote object using the XPC service's published protocol
        _connection.remoteObjectInterface = NSXPCInterface(with: XPCServiceProtocol.self)

        // In order to achieve bidirectional communication between the client app and the XPC service, we must
        //  additionally set the exported object and exported interface of the connection we have just created.
        _connection.exportedObject = self
        _connection.exportedInterface = NSXPCInterface(with: ClientProtocol.self)

        // Configure the XPC connection's interruption handler
        _connection.interruptionHandler = {

          // If the interruption handler has been called, the XPC connection remains valid, and the
          // the XPC service will automatically be re-launched with future calls to the connection object
          NSLog("connection to XPC service has been interrupted")
        }

        // Configure the XPC connection's invalidation handler
        _connection.invalidationHandler = {

          // If the invalidation handler has been called, the XPC connection is no longer valid and must be recreated
          NSLog("connection to XPC service has been invalidated")
          self._connection = nil
        }

        // New connections must be resumed before use
        _connection.resume()

        NSLog("successfully connected to XPC service")
      }


    public func xpcService() -> XPCServiceProtocol
      {
        // If this is the first call to the XPC service, or if the connection was just invalidated, we'll need to create a new connection
        if _connection == nil {
          NSLog("no connection to XPC service")
          establishConnection()
        }

        // Return the connection's remote object proxy
        return _connection.remoteObjectProxyWithErrorHandler { err in
          print(err)
        } as! XPCServiceProtocol
      }


    // This function exists solely to demonstrate connection invalidation error handling
    func invalidateConnection() -> Void
      {
        // Ensure we have a connection to invalidate
        guard _connection != nil else { NSLog("no connection to invalidate"); return }

        // Invalidate the connection
        _connection.invalidate()
      }


    // MARK: ClientProtocol

    func incrementCount()
      {
        // Because this method is updating a Published variable, but will be called on a background thread,
        // We need to ensure that the logic to modify the count is run on the main thread
        DispatchQueue.main.async { self.count += 1 }
      }

  }
