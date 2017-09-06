//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 30.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit
import CoreLocation

struct Coordinates {
  let latitude: Double
  let longitude: Double
  let locationName: String
}

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
  
  typealias LocationClousure = (Coordinates?, NSError?) -> ()
  var handler: LocationClousure!
  var isFirstUpdating = true
  
  func getCurrentLocation(completionHandler: @escaping LocationClousure) {
    isFirstUpdating = true
    delegate = self
    desiredAccuracy = kCLLocationAccuracyBest
    distanceFilter = 100
    requestAlwaysAuthorization()
    startUpdatingLocation()
    handler = { coordinate, error in
      completionHandler(coordinate, error)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if isFirstUpdating {
      let userLocation = locations.last! as CLLocation
      
      let geocoder = CLGeocoder()
      geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
        
        if let placemark = placemarks?.last {
          var addressString = ""
          if let locality = placemark.locality {
            addressString = locality
          } else {
            addressString = placemark.administrativeArea!
          }
          let coordinate = Coordinates(latitude: userLocation.coordinate.latitude,
                                       longitude: userLocation.coordinate.longitude,
                                       locationName: addressString)
          self.handler(coordinate, nil)
          self.isFirstUpdating = false
          self.stopUpdatingLocation()
        } else {
          self.handler(nil, nil)
        }
        
        if let error = error as NSError? {
          self.handler(nil, error)
          return
        }
      }
    }
  }
}
