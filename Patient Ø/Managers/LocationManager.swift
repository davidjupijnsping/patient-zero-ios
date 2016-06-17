//
//  LocationManager.swift
//  Patient Ø
//
//  Created by Silvain on 16-06-16.
//  Copyright © 2016 Sping. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  typealias locationCallback = (location: CLLocation) -> Void

  var locationManager = CLLocationManager()
  var onLocationChange: locationCallback?
  var lastLocation: CLLocation?

  func setupLocationManager() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    if CLLocationManager.authorizationStatus() == .NotDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }

  func startUpdatingLocation(onLocationChangeCallback: locationCallback) {
    self.onLocationChange = onLocationChangeCallback
    locationManager.startUpdatingLocation()
  }

  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last!
    if location != lastLocation {
      lastLocation = location
      if onLocationChange != nil {
        onLocationChange!(location:location)
      }
    }
  }
}