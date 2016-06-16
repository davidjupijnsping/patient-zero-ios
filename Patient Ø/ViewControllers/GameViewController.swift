//
//  ViewController.swift
//  Patient Ø
//
//  Created by David Jupijn on 10/06/16.
//  Copyright © 2016 Sping. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class GameViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var startGameButton: UIButton!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapStartGame(sender: UIButton) {

        sendStartGameRequest()
    }

    private func sendStartGameRequest() {

        Alamofire.request(.GET, "\(apiURL)games.json", parameters: nil)
            .responseJSON { response in
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
//                    debugPrint("JSON: \(json)")
                    GameManager.sharedInstance.startGame(GameInfo(json:json))
                    self.startGameButton.hidden = true
                    self.locationManager.startUpdatingLocation()
                }
        }

    }

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {

        }
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {

        if newLocation.coordinate != oldLocation.coordinate {
//            debugPrint("GOT A NEW LOCATION BRUH! \(newLocation)")
            postUserLocation(newLocation)
            GameManager.sharedInstance.userLocation = newLocation
        }
    }

    func postUserLocation(location: CLLocation) {
        if GameManager.sharedInstance.started && GameManager.sharedInstance.gameInfo != nil && GameManager.sharedInstance.userLocation != nil {
            let params = ["location": ["game_id": GameManager.sharedInstance.gameInfo!.id, "lat": GameManager.sharedInstance.userLocation!.coordinate.latitude, "long": GameManager.sharedInstance.userLocation!.coordinate.longitude]]
            Alamofire.request(.POST, "\(apiURL)locations.json", parameters: params)
            .responseJSON { response in
                debugPrint("posted userlocation")

            }
        }

    }
}

