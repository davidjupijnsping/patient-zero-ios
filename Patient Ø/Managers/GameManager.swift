//
//  GameManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class GameManager: NSObject {
  var locationManager = LocationManager()
  var vibrationManager = VibrationManager()
  var socketManager = SocketManager()
  var soundManager = SoundManager()
  var hordes: Array<Horde> = []

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
    UIApplication.sharedApplication().idleTimerDisabled = false
    gameStarted = false
    gameInfo = nil
    locationManager.stopUpdatingLocation()
    vibrationManager.stopHeartbeat()
    socketManager.stopGame()
    soundManager.stopHazardSound()

    onStoppedCallback()
  }

  private func startGameConfirmed(info: GameInfo) {
    UIApplication.sharedApplication().idleTimerDisabled = true
    gameInfo = info
    gameStarted = true
    vibrationManager.startHeartbeat()
    locationManager.startUpdatingLocation() { location in
      self.locationUpdate(location)
    }
    socketManager.openConnection(self) {

    }
    soundManager.playHazardSound()
  }

  func locationUpdate(location: CLLocation) {
    if gameStarted && gameInfo != nil {
      sendLocationToServer(location)
      checkHazards(location)
      updateHeartbeat(location)
    }
  }

  private func sendLocationToServer(location: CLLocation) {
    let params = ["location": ["game_id": gameInfo!.id, "lat": location.coordinate.latitude, "long": location.coordinate.longitude]]
    Alamofire.request(.POST, "\(apiURL)locations.json", parameters: params)
      .responseJSON { response in
//        debugPrint("posted userlocation")
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

  func handleAction(json: JSON) {
    switch json["action"] {
    case "update_horde":
      updateHorde(json)
      break
    default: break
    }
  }

  func updateHorde(json: JSON) {
    let horde = Horde(json: json["horde"])
    print( "size of horde is: \(horde.radius)")

    if let found = hordes.indexOf({ $0.id == horde.id }) {
      let existingHorde = hordes[found]
      existingHorde.updateCoordinate(json["horde"])
      // update location
    } else {
      // add horde 
      hordes.append(horde)
    }
  }

  func checkHazards(location: CLLocation) {
    var closest = dangerDistance
    for horde in hordes {
      let distance = horde.distanceFromLocation(location)
      if distance < dangerDistance {
        if distance < closest {
          closest = distance
        }
      }
    }

    soundManager.updateVolume(closest)
  }
}
