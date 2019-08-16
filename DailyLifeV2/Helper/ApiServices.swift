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
  //NewsApi Key (lygialong2911@gmail.com): 2173e6f5b41e4cb7b3892eb3ace459c5
  //NewsApi Key (lygialiem2911@gmail.com): 1ba7ebe1f90e4f3b87643898c85b84f3
  let BASE_URL_NEWSAPI = "https://newsapi.org/v2/everything?q="
  let API_KEY_NEWSAPI = "d5b74e34a5d84c6e975e1cfe78f4803d"
  let TOPIC_NEWSAPI = ["World", "Politics", "Business", "Opinion", "Technology", "Science", "Arts", "Food", "Health", "Entertainment", "Style", "Travel", "Sport"]
  
  func getNewsApi(topic: String, completion: @escaping (NewsApi) -> Void){
    let totalUrl = "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=20&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&domains=vice.com&page=1"
    
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
  
  func getMoreNewsApi(topic: String, page: Int, completion: @escaping (NewsApi) -> Void){
    
    let totalUrl =  "\(BASE_URL_NEWSAPI)\(topic)&language=en&pageSize=20&apiKey=\(API_KEY_NEWSAPI)&sortBy=publishedAt&domains=nytimes.com&page=\(page)"
    guard let url = URL(string: totalUrl) else {return}
    URLSession.shared.dataTask(with: url) {(dataApi, response, error) in
      
      guard let data = dataApi else {return}
      do{
        let dataDecode = try JSONDecoder().decode(NewsApi.self, from: data)
        completion(dataDecode)
      } catch let jsonError{
        debugPrint("LOI: ", jsonError)
      }
    }.resume()
  }
}
