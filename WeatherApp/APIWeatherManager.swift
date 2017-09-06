//
//  APIWeatherManager.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 30.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import Foundation

enum ForecastType: FinalURLPoint {
  case current(apiKey: String, coordinates: Coordinates)
  
  var baseURL: URL {
    return URL(string: "https://api.darksky.net")!
  }
  var path: String {
    switch self {
    case .current(let apiKey, let coordinates):
      return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)?units=si"
    }
  }
  var request: URLRequest {
    return URLRequest(url: URL(string: path, relativeTo: baseURL)!)
  }
}

final class APIWeatherManager: APIManager {
  
  let sessionConfiguration: URLSessionConfiguration
  lazy var session: URLSession = {
    return URLSession(configuration: self.sessionConfiguration)
  }()
  
  let apiKey: String
  
  init(configuration: URLSessionConfiguration, apiKey: String) {
    self.sessionConfiguration = configuration
    self.apiKey = apiKey
  }
  
  convenience init(apiKey: String) {
    self.init(configuration: .default, apiKey: apiKey)
  }
  
  func fetchCurrentWeather(with coordinates: Coordinates,
                           and completionHandler: @escaping (APIResult<CurrentWeather>) -> ()) {
    
    let request = ForecastType.current(apiKey: self.apiKey, coordinates: coordinates).request
    
    fetch(request: request, parse: { (json) -> CurrentWeather? in
      if let dictionary = json["currently"] as? [String: Any] {
        return CurrentWeather(JSON: dictionary)
      } else {
        return nil
      }
    }, completionHandler: completionHandler)
  }
  
}








