//
//  GameInfo.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class GameInfo: NSObject {
  var id: Int
  var name: String
  var coordinate: CLLocation
  var coordinatePatientØ: CLLocation
  var coordinateCDC: CLLocation
  var url: String
  var finished: Bool

  required init(json: JSON) {
    id = json["id"].intValue
    name = json["name"].stringValue
    coordinate = CLLocation(latitude: json["lat"].doubleValue, longitude: json["long"].doubleValue)
    coordinatePatientØ = CLLocation(latitude: json["lat"].doubleValue, longitude: json["long"].doubleValue)
    coordinateCDC = CLLocation(latitude: json["cdc_lat"].doubleValue, longitude: json["cdc_long"].doubleValue)
    url = json["url"].stringValue
    finished = json["finished"].boolValue
  }

  func distanceFromLocation(location: CLLocation) -> CLLocationDistance {
    let distance = location.distanceFromLocation(coordinate)
    return distance
  }
}
