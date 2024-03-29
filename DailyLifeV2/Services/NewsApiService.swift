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
  
  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let API_KEY_NEWSAPI = "6d8a8f003e444d1fa411ff9ccf0a60c6"
  var TOPIC_NEWSAPI = ["World", "Politics", "Business", "Opinion", "Technology", "Science", "Arts", "Food", "Health", "Entertainment", "Style", "Travel", "Sport"]
  
  func getMoreNewsApi(topic: String, page: Int, numberOfArticles: Int, completion: @escaping (NewsApi?) -> Void){
    
    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=\(numberOfArticles)&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&page=\(page)&domains=cnn.com,nytimes.com,vice.com,foxnews.com,news.google.com"
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) {(dataApi, response, error) in
      guard let data = dataApi else {return}
      do{
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError{
        debugPrint("API Key for NewsApi is Out Of Date: ", jsonError)
      }
    }.resume()
  }
}
