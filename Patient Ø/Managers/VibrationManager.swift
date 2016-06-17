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
  var heartbeatActive: Bool = false
  var heartbeatInterval = 10.0
  var heartbeatTimer: NSTimer?
  var heartbeatTimer2: NSTimer?

  func startHeartbeat() {
    if !heartbeatActive {
      heartbeatActive = true
      scheduleNextHeartbeat()
    }
  }

  func stopHeartbeat() {
    if heartbeatActive {
      heartbeatActive = false
      heartbeatTimer?.invalidate()
      heartbeatTimer2?.invalidate()
      heartbeatTimer = nil
      heartbeatTimer2 = nil
    }
  }

  func changeHeartbeatInterval(interval: Double) {
    let oldHeartbeatInterval = self.heartbeatInterval
    self.heartbeatInterval = interval

    if heartbeatActive {
      if heartbeatTimer == nil {
        heartbeatTimer = NSTimer.scheduledTimerWithTimeInterval(heartbeatInterval, target: self, selector: #selector(VibrationManager.heartbeatTrigger), userInfo: nil, repeats: false)
      } else {
        var timeRemaining = heartbeatTimer!.fireDate.timeIntervalSinceNow - (oldHeartbeatInterval - heartbeatInterval)
        if timeRemaining < 0 {
          timeRemaining = 0.1
        }

        if timeRemaining < 0.5 && heartbeatTimer2 != nil {
          heartbeatTimer2?.invalidate()
          heartbeatTimer2 = nil
        }

        heartbeatTimer?.invalidate()
        heartbeatTimer = NSTimer.scheduledTimerWithTimeInterval(heartbeatInterval, target: self, selector: #selector(VibrationManager.heartbeatTrigger), userInfo: nil, repeats: false)
      }
    }
  }

  private func scheduleNextHeartbeat() {
    heartbeatTimer = NSTimer.scheduledTimerWithTimeInterval(heartbeatInterval, target: self, selector: #selector(VibrationManager.heartbeatTrigger), userInfo: nil, repeats: false)
  }

  func heartbeatTrigger() {
    playHeartbeat()
    scheduleNextHeartbeat()
  }

  private func playHeartbeat() {
    heartbeatTimer = nil
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    if heartbeatInterval > 0.5 {
      heartbeatTimer2 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(VibrationManager.playSecondHeartbeat), userInfo: nil, repeats: false)
    }
  }

  func playSecondHeartbeat() {
    heartbeatTimer2 = nil
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }
}
