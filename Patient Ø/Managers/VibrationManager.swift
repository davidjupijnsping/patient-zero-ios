//
//  VibrationManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import AudioToolbox

class VibrationManager: NSObject {
    static let sharedInstance = VibrationManager()
    var heartBeatPace:Int32 = 120

    enum VibratePattern: Int {
        case HeartBeat = 0
    }

/*    func customVibration() {
        var dict = NSMutableDictionary()
        var array = Array<NSNumber>()

        array.append(NSNumber(bool: true))
        array.append(NSNumber(int: 1000 * heartBeatPace))
        array.append(NSNumber(bool: false))
        array.append(NSNumber(int: 1000 * heartBeatPace))

        dict.setObject(array, forKey: "VibePattern")
        dict.setObject(NSNumber(int:1), forKey: "Intensity")

        AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dict)
    }*/
}
