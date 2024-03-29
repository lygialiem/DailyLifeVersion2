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
  
  let APIXU_KEY = "c24ce9be9f664eb29a1141134192208"
  
  func getWeatherApi(latitude: Double, longitude: Double, completion: @escaping (CurrentlyDarkSkyApi) -> Void){
    let totalUrl = URL(string: "\(BASE_URL)\(DARKSKY_KEY)/\(latitude),\(longitude)/?exclude=daily,hourly,minutely,alerts,flags&units=ca")
    guard let url = totalUrl else {return}
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {return}
      do{
        let dataDecode = try JSONDecoder().decode(CurrentlyDarkSkyApi.self, from: data)
        completion(dataDecode)
      }catch let jsonError{
        debugPrint(jsonError)
      }
      }.resume()
  }
  
  func getCountryForecastApi(nameOfCountry: String, completion: @escaping (ForecastApi?) -> Void, completionCoordinate: @escaping (HourlyDarkSkyApi) -> Void){
    let url = "http://api.apixu.com/v1/forecast.json?key=\(APIXU_KEY)&q=\(nameOfCountry.replacingOccurrences(of: " ", with: "%20"))&days=7"
    guard let urlRequest = URL(string: url) else {return}
    
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      if error == nil {
        guard let data = data else {return}
        do {
          let dataDecoded = try JSONDecoder().decode(ForecastApi.self
            , from: data)
          guard let latitude = dataDecoded.location?.lat, let longitude = dataDecoded.location?.lon else {return}
          guard let darkSkyApi = URL(string: "\(self.BASE_URL)\(self.DARKSKY_KEY)/\(latitude),\(longitude)/?exclude=daily,currently,minutely,alerts,flags&units=ca") else {return}
          
          URLSession.shared.dataTask(with: darkSkyApi) {(data, response, error) in
            guard let data = data else {return}
            do {
              let dataDecoded = try JSONDecoder().decode(HourlyDarkSkyApi.self, from: data)
              completionCoordinate(dataDecoded)
            }catch let jsonError{
              debugPrint("getConutryForecastApi: ", jsonError)
            }
          }.resume()
          completion(dataDecoded)
        } catch let jsonError{
          debugPrint("getConutryForecastApi: ", jsonError)
        }
      }
      }.resume()
  }

  
  func getIconJson(completion: @escaping ([Info]) -> Void){
    let urlRequest = URL(string: "http://www.apixu.com/doc/Apixu_weather_conditions.json")
    guard let url = urlRequest else {return}
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else {return}
      do {
       let dataDecoded = try JSONDecoder().decode([Info].self, from: data)
        completion(dataDecoded)

      }catch{
        debugPrint("ErrorCallAPi: \(String(describing: error))")      }
    }.resume()
    
  }
  
}
