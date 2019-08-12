//
//  ApiServices.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

class ApiServices{
  static let instance = ApiServices()
  //NewsApi Key (lygialam2911@gmail.com): d5b74e34a5d84c6e975e1cfe78f4803d
  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let API_KEY_NEWSAPI = "d5b74e34a5d84c6e975e1cfe78f4803d"
  let TOPIC_NEWSAPI = ["World", "Politics", "Business", "Health", "Entertainment", "Style", "Travel", "Sport"]
  
  func getNewsApi(topic: String, completion: @escaping (NewsApi) ->()){
    let totalUrl = "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=20&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&domains=cnn.com"
    
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) { (data, reponse, error) in
      guard let data = data else {return}
      do {
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      }catch let jsonError{
        debugPrint(jsonError)
      }
    }.resume()
  }
}
