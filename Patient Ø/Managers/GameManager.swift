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

  //  var userLocation: CLLocation?
  //  var endCoordinate: CLLocationCoordinate2D?

  func setupGameManager() {
    locationManager.setupLocationManager()
  }

  func startGame(callback: () -> Void) {
    Alamofire.request(.GET, "\(apiURL)games.json", parameters: nil)
      .responseJSON { response in
        if response.result.value != nil {
          let json = JSON(response.result.value!)
          self.startGameConfirmed(GameInfo(json:json))
          callback()
        } else {
          callback(/*error*/) // TODO: error handling
        }
    }
  }

  func stopGame(callback: () -> Void) {
    // TODO: stop the game
    callback()
  }

  private func startGameConfirmed(info: GameInfo) {
    gameInfo = info
    gameStarted = true
    locationManager.startUpdatingLocation() { location in
      self.locationUpdate(location)
    }
  }

  func locationUpdate(location: CLLocation) {
    if gameStarted && gameInfo != nil {
      let params = ["location": ["game_id": gameInfo!.id, "lat": location.coordinate.latitude, "long": location.coordinate.longitude]]
      Alamofire.request(.POST, "\(apiURL)locations.json", parameters: params)
        .responseJSON { response in
          debugPrint("posted userlocation")
      }
    }
  }
}
