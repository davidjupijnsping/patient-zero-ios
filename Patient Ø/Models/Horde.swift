//
//  Horde.swift
//  Patient Ø
//
//  Created by David Jupijn on 17/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class Horde: NSObject {
  var id: Int
  var action: String
  var coordinate: CLLocation
  var radius: Double


  required init(json: JSON) {
    id = json["id"].intValue
    action = json["action"].stringValue
    coordinate = CLLocation(latitude: json["lat"].doubleValue, longitude: json["long"].doubleValue)
    radius = json["radius"].doubleValue
  }

  func updateCoordinate(json: JSON) {
    coordinate = CLLocation(latitude: json["lat"].doubleValue, longitude: json["long"].doubleValue)
  }

  func distanceFromLocation(location: CLLocation) -> CLLocationDistance {
    let distance = location.distanceFromLocation(coordinate) - radius
    return distance
  }
}
