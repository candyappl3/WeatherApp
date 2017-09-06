//
//  APIManager.swift
//  WeatherApp
//
//  Created by Dmitry Shadrin on 30.08.17.
//  Copyright © 2017 Dmitry Shadrin. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?) -> ()

enum APIResult<T> {
  case success(T)
  case failure(Error)
}

protocol JSONDecodable {
  init?(JSON: [String: Any])
}

protocol FinalURLPoint {
  var baseURL: URL { get }
  var path: String { get }
  var request: URLRequest { get }
}

protocol APIManager {
  var sessionConfiguration: URLSessionConfiguration { get }
  var session: URLSession { get }
  
  func JSONTask(with request: URLRequest,
                completionHandler: @escaping JSONCompletionHandler) -> JSONTask
  
  func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: Any]) -> T?,
             completionHandler: @escaping (APIResult<T>) -> ())
}

extension APIManager {
  func JSONTask(with request: URLRequest,
                completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
    
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      guard let HTTPResponse = response as? HTTPURLResponse else {
        
        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
        ]
        
        let error = NSError(domain: DSNetworkingErrorDomain,code: MissingHTTPResponseError,
                            userInfo: userInfo)
        
        completionHandler(nil, nil, error)
        return
      }
      
      if data == nil {
        if let error = error {
          completionHandler(nil, HTTPResponse, error)
        }
      } else {
        switch HTTPResponse.statusCode {
        case 200:
          do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            completionHandler(json, HTTPResponse, nil)
          } catch let error as NSError {
            completionHandler(nil, HTTPResponse, error)
          }
        default:
          print("We have got response status \(HTTPResponse.statusCode)")
        }
      }
    }
    return dataTask
  }
  
  func fetch<T>(request: URLRequest, parse: @escaping ([String: Any]) -> T?,
             completionHandler: @escaping (APIResult<T>) -> ()) {
    
    let dataTask = JSONTask(with: request) { (json, response, error) in
      DispatchQueue.main.async {
        guard let json = json else {
          if let error = error {
            completionHandler(.failure(error))
          }
          return
        }
        
        if let value = parse(json) {
          completionHandler(.success(value))
        } else {
          let error = NSError(domain: DSNetworkingErrorDomain, code: UnexpectedResponseError,
                              userInfo: nil)
          completionHandler(.failure(error))
        }
      }
    }
    dataTask.resume()
  }
}
