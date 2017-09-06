//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 29.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var presureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var feelsLikeLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let locationManager = LocationManager()
  
  lazy var weatherManager = APIWeatherManager(apiKey: "e37f6258d4c8e81a8f5cdea734d36385")
   var coordinates: Coordinates!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getCurrentLocation()
  }
  
  func getCurrentLocation() {
    locationManager.getCurrentLocation { [unowned self] currentCoordinates, error in
      
      guard error == nil else {
        self.showFailureAlert(with: error!)
        return
      }
      
      if let newCoordinates = currentCoordinates {
        self.coordinates = newCoordinates
        self.getCurrentWeather()
      }
    }
  }
  
  func updateUI(with weather: CurrentWeather) {
    weatherIcon.image = weather.icon
    presureLabel.text = weather.pressureString
    humidityLabel.text = weather.humidityString
    feelsLikeLabel.text = weather.appearentTemperatureString
    temperatureLabel.text = weather.temperatureString
    locationLabel.text = coordinates.locationName
  }
  
  func getCurrentWeather() {
    weatherManager.fetchCurrentWeather(with: coordinates) { [unowned self] (result) in
      switch result {
      case .success(let currentWeather):
        self.updateUI(with: currentWeather)
        self.activityIndicator.stopAnimating()
      case .failure(let error as NSError):
        self.showFailureAlert(with: error)
      default: break
      }
    }

  }
  
  func showFailureAlert(with error: NSError) {
    let alert = UIAlertController(title: "Unable to get data", message: error.localizedDescription,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func refreshAction(_ sender: UIButton) {
    self.activityIndicator.startAnimating()
    getCurrentLocation()
  }
  
  
}
