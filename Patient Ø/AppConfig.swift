//
//  AppConfig.swift
//  CleanPlaza
//
//  Created by David Jupijn on 12/02/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit

enum Environment {
  case Development
  case Staging
  case Production
}

let environment = Environment.Development
let apiURL = environment == .Staging ? "" : environment == .Development ? "https://f61a643b.ngrok.io/" : environment == .Production ? "" : ""
let socketURL = environment == .Staging ? "" : environment == .Development ? "ws://f61a643b.ngrok.io/cable" : environment == .Production ? "" : ""

let supportedActions = ["update_horde"]
let dangerDistance = Double(20) // distance in meters