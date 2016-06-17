//
//  SocketManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 17/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import ActionCableClient
import SwiftyJSON

class SocketManager: NSObject {

  var gameManager: GameManager?
  var client = ActionCableClient(URL: NSURL(string: socketURL)!)
  
  func openConnection(gameManager: GameManager, onStartedCallback: () -> Void) {
    self.gameManager = gameManager
    // Connect!
    client.connect()

    client.onConnected = {
      print("Connected!")
    }

    client.onDisconnected = {(error: ErrorType?) in
      print("Disconnected! " + error.debugDescription)
    }

    let roomChannel = client.create("MessagesChannel") // The channel name must match the class name on the server

    // Receive a message from the server. Typically a Dictionary.
    roomChannel.onReceive = { (result: AnyObject?, error: ErrorType?) in
      let json = JSON(result!)
      if supportedActions.contains(json["action"].stringValue) {
        self.gameManager!.handleAction(json)
        print("Received ", result)
      }
    }

    // A channel has successfully been subscribed to.
    roomChannel.onSubscribed = {
      print("Yay!")
    }

    // A channel was unsubscribed, either manually or from a client disconnect.
    roomChannel.onUnsubscribed = {
      print("Unsubscribed")
    }

    // The attempt at subscribing to a channel was rejected by the server.
    roomChannel.onRejected = {
      print("Rejected")
    }

    onStartedCallback()
  }

  func stopGame() {
    client.disconnect()
  }

}
