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
let apiURL = environment == .Staging ? "" : environment == .Development ? "http://64a795f6.ngrok.io/" : environment == .Production ? "" : ""
