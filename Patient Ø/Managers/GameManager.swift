//
//  GameManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class GameManager: NSObject {
  var locationManager = LocationManager()
  var vibrationManager = VibrationManager()

  var gameStarted = false
  var gameInfo: GameInfo?

  func setupGameManager() {
    locationManager.setupLocationManager()
  }

  func startGame(onStartedCallback: () -> Void) {
    Alamofire.request(.GET, "\(apiURL)games.json", parameters: nil)
      .responseJSON { response in
        if response.result.value != nil {
          let json = JSON(response.result.value!)
          self.startGameConfirmed(GameInfo(json:json))
          onStartedCallback()
        } else {
          onStartedCallback(/*error*/) // TODO: error handling
        }
    }
  }

  func stopGame(onStoppedCallback: () -> Void) {
    // TODO: stop the game
    locationManager.stopUpdatingLocation()
    vibrationManager.stopHeartbeat()
    onStoppedCallback()
  }

  private func startGameConfirmed(info: GameInfo) {
    gameInfo = info
    gameStarted = true
    vibrationManager.startHeartbeat()
    locationManager.startUpdatingLocation() { location in
      self.locationUpdate(location)
    }
  }

  func locationUpdate(location: CLLocation) {
    if gameStarted && gameInfo != nil {
      sendLocationToServer(location)
      updateHeartbeat(location)
    }
  }

  private func sendLocationToServer(location: CLLocation) {
    let params = ["location": ["game_id": gameInfo!.id, "lat": location.coordinate.latitude, "long": location.coordinate.longitude]]
    Alamofire.request(.POST, "\(apiURL)locations.json", parameters: params)
      .responseJSON { response in
        debugPrint("posted userlocation")
    }
  }

  private func updateHeartbeat(location: CLLocation) {
    let distance = gameInfo!.distanceFromLocation(location)
    let heartbeatInterval = determineHeartbeatInterval(distance)
    vibrationManager.changeHeartbeatInterval(heartbeatInterval)
  }

  private func determineHeartbeatInterval(distance: CLLocationDistance) -> Double {
    if distance > 100 {
      return 10.0
    } else {
      return distance/10.0
    }
  }
}
