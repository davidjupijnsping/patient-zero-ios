//
//  GameManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import CoreLocation

class GameManager: NSObject {
    static let sharedInstance = GameManager()

    var userLocation: CLLocation?
    var endCoordinate: CLLocationCoordinate2D?
    var gameInfo: GameInfo?
    var started = false

    func startGame(info: GameInfo) {
        gameInfo = info
        started = true
    }
}
