//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 29.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
  let temperature: Double
  let apparentTemperature: Double
  let humidity: Double
  let pressure: Double
  let icon: UIImage
}

extension CurrentWeather: JSONDecodable {
  init?(JSON: [String : Any]) {
    guard let temperature = JSON["temperature"] as? Double,
      let apparentTemperature = JSON["apparentTemperature"] as? Double,
      let humidity = JSON["humidity"] as? Double,
      let pressure = JSON["pressure"] as? Double,
      let iconString = JSON["icon"] as? String else {
        return nil
    }
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
    self.humidity = humidity
    self.pressure = pressure
    self.icon = WeatherIconManager(rawValue: iconString).image
  }
}

extension CurrentWeather {
  var temperatureString: String {
    return "\(Int(temperature))˚C"
  }
  var appearentTemperatureString: String {
    return "Feels like: \(Int(apparentTemperature))˚C"
  }
  var humidityString: String {
    return "\(Int(humidity * 100))%"
  }
  var pressureString: String {
    return "\(Int(pressure * 0.750062)) mm"
  }
}
