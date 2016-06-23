//
//  ViewController.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import SAConfettiView

class GameViewController: UIViewController, GameManagerDelegate {
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var startGameButton: UIButton!
  var confettiView = SAConfettiView()
  var statusMessage: String = ""

  var gameManager = GameManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    gameManager.setupGameManager(self)

    confettiView = SAConfettiView(frame: self.view.frame)
    confettiView.userInteractionEnabled = false
    confettiView.colors = [UIColor(red:0.95, green:0.0, blue:0.27, alpha:1.0)]
    statusLabel.text = statusMessage
    startGameButton.layer.borderColor = UIColor.redColor().CGColor
    startGameButton.layer.borderWidth = 1
    startGameButton.layer.cornerRadius = 10

    self.view.addSubview(confettiView)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func didTapStartGame(sender: UIButton) {
    if gameManager.gameStarted {
      gameManager.stopGame() {
        self.startGameButton.setTitle("Start game".uppercaseString, forState: .Normal)
        self.statusLabel.text = ""
      }
    } else {
      gameManager.startGame() {
        self.startGameButton.setTitle("Stop game".uppercaseString, forState: .Normal)
        self.confettiView.stopConfetti()
        self.statusMessage = "Find Patient Ø"
        self.statusLabel.text = self.statusMessage
        // TODO: error handling
      }
    }
  }

  func didSaveTheWorld() {
    // Set colors (default colors are red, green and blue)
    confettiView.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                           UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                           UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                           UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                           UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]

    confettiView.intensity = 1
    confettiView.type = .Confetti
    confettiView.startConfetti()
//    self.view.addSubview(confettiView)
    self.startGameButton.setTitle("Start game".uppercaseString, forState: .Normal)

    statusMessage = "You just saved the world like a boss!"
    statusLabel.text = statusMessage
  }

  func gotEaten() {
    if !confettiView.isActive() {
      // Set colors (default colors are red, green and blue)
      confettiView.colors = [UIColor(red:0.9859, green:0.0, blue:0.2109, alpha:1.0)]
      confettiView.intensity = 1
      confettiView.type = .Diamond
      confettiView.startConfetti()
//      self.view.addSubview(confettiView)
    }
    print("Yeah you just kinda got eaten by a horde of zombies bruh!")
  }

  // Only for demo purposes. Should not be in final product unless we want to take damage.
  func stopGettingEaten() {
    if confettiView.isActive() {
      confettiView.colors = [UIColor(red:0.9859, green:0.0, blue:0.2109, alpha:0.0)]
      confettiView.intensity = 0
      confettiView.stopConfetti()
//      confettiView.removeFromSuperview()
    }
  }

  func foundPatientØ() {
    statusMessage = "Bring Patient Ø to the CDC!"
    statusLabel.text = statusMessage
  }
}

