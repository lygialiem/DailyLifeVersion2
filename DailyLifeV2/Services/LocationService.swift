//
//  LocationService.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService{
  
  static let instance = LocationService()
  
  let weatherTitles = ["time", "summary", "latitude", "longitude", "temperature", "humidity", "pressure","nearest Storm Distance", "precip Intensity", "precip Type", "precip Probability", "dew point", "wind Bearing", "ozone",  "cloud Cover", "visibility", "UV Index"]
  
  let DARKSKY_KEY = "060b23f6abfddd1f77ad14c3968b71db"
  let BASE_URL = "https://api.darksky.net/forecast/"
  
  func getWeatherApi(latitude: Double, longitude: Double, completion: @escaping (WeatherInfo) -> Void){
    let totalUrl = URL(string: "\(BASE_URL)\(DARKSKY_KEY)/\(latitude),\(longitude)/?exclude=daily,hourly,minutely,alerts,flags&units=ca")
    guard let url = totalUrl else {return}
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {return}
      do{
        let dataDecode = try JSONDecoder().decode(WeatherInfo.self, from: data)
        completion(dataDecode)
      }catch let jsonError{
        debugPrint(jsonError)
      }
      }.resume()
  }
}
