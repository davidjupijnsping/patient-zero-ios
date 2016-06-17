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
    var url: String
    var finished: Bool

    required init(json: JSON) {
        id = json[0]["id"].intValue
        name = json[0]["name"].stringValue
        coordinate = CLLocation(latitude: json[0]["lat"].doubleValue, longitude: json[0]["long"].doubleValue)
        url = json[0]["url"].stringValue
        finished = json[0]["finished"].boolValue
    }

  func distanceFromLocation(location: CLLocation) -> CLLocationDistance {
    let distance = location.distanceFromLocation(coordinate)
    return distance
  }
}
