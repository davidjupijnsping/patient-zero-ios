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
  var helpSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("help", ofType: "wav")!)
  var audioPlayer = AVAudioPlayer()
  var audioPlayerHelp = AVAudioPlayer()
  var volume = Double(0)
  var volumeHelp = Double(0)
  var fader: Fader?
  var faderHelp: Fader?

  func updateVolume(distance: Double) {
    var calculatedVolume = volumeForDistance(distance)
    if calculatedVolume < 0 {
      calculatedVolume = 0
    }
//    audioPlayer.volume = volume
    fader!.fade(fromVolume: self.volume, toVolume: calculatedVolume, duration: 1, velocity: 2) { (success) in
      // Do nothing
    }
    volume = Double(calculatedVolume)
  }

  func updateVolumeHelp(distance: Double) {
    var calculatedVolumeHelp = volumeForDistance(distance)
    if calculatedVolumeHelp < 0 {
      calculatedVolumeHelp = 0
    }
    //    audioPlayer.volume = volume
    faderHelp!.fade(fromVolume: self.volumeHelp, toVolume: calculatedVolumeHelp, duration: 1, velocity: 2) { (success) in
      // Do nothing
    }
    volumeHelp = Double(calculatedVolumeHelp)
  }

  private func volumeForDistance(distance: Double) -> Double {
    return 1 - (distance / dangerDistance)
  }

  func playHazardSound() {
    do {
      audioPlayer = try AVAudioPlayer(contentsOfURL: hazardSound)
      audioPlayer.volume = 0
      audioPlayer.play()
      audioPlayer.numberOfLoops = Int.max
      fader = Fader(player: audioPlayer)

    } catch {

    }
  }

  func playHelpSound() {
    do {
      audioPlayerHelp = try AVAudioPlayer(contentsOfURL: helpSound)
      audioPlayerHelp.volume = 0
      audioPlayerHelp.play()
      audioPlayerHelp.numberOfLoops = Int.max
      faderHelp = Fader(player: audioPlayerHelp)

    } catch {

    }
  }

  func stopHelpSound() {
    audioPlayerHelp.stop()
    volumeHelp = 0
  }

  func stopHazardSound() {
    audioPlayer.stop()
    volume = 0
  }

}
