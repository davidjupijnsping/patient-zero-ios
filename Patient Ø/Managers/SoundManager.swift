//
//  SoundManager.swift
//  Patient Ø
//
//  Created by David Jupijn on 17/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager: NSObject {
  var hazardSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("zombie", ofType: "wav")!)
  var audioPlayer = AVAudioPlayer()
  var volume = Float(0)

  func updateVolume(distance: Double) {
    var calculatedVolume = volumeForDistance(distance)
    if calculatedVolume < 0 {
      calculatedVolume = 0
    }
    volume = Float(calculatedVolume)
    audioPlayer.volume = volume
  }

  private func volumeForDistance(distance: Double) -> Double {
    return 1 - (distance / dangerDistance)
  }

  func playHazardSound() {
    do {
      audioPlayer = try AVAudioPlayer(contentsOfURL: hazardSound)
      audioPlayer.volume = volume
      audioPlayer.play()
    } catch {

    }
  }

  func stopHazardSound() {
    audioPlayer.stop()
    volume = 0
  }

}
