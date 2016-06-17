//
//  ViewController.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  @IBOutlet weak var startGameButton: UIButton!

  var gameManager = GameManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    gameManager.setupGameManager()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func didTapStartGame(sender: UIButton) {
    if gameManager.gameStarted {
      gameManager.stopGame() {
        self.startGameButton.titleLabel?.text = "Start game".uppercaseString
      }
    } else {
      gameManager.startGame() {
        self.startGameButton.titleLabel?.text = "Stop game".uppercaseString
        // TODO: error handling
      }
    }
  }
}

