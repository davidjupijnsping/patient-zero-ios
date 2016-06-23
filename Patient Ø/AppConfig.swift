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
let apiURL = environment == .Staging ? "" : environment == .Development ? "https://patient-zero.herokuapp.com/" : environment == .Production ? "" : ""
let socketURL = environment == .Staging ? "" : environment == .Development ? "wss://patient-zero.herokuapp.com/cable" : environment == .Production ? "" : ""

let supportedActions = ["update_horde"]
let dangerDistance = Double(10) // distance in meters
let rescueDistance = Double(5)