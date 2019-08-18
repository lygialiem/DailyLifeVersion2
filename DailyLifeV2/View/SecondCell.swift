//
//  SecondCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class SecondCell: UITableViewCell {
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var timePublishedArticle: UILabel!
  

  var imageArticleName: String!{
    didSet{
      selectionStyle = UITableViewCell.SelectionStyle.none
      imageArticle.clipsToBounds = true
      imageArticle.layer.cornerRadius = 10
      imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      imageArticle.layer.borderWidth = 2
      let url = URL(string: imageArticleName)
      imageArticle.sd_setImage(with: url, completed: nil)
    }
  }
  
  var titleArticleName: String!{
    didSet{
      titleArticle.text = titleArticleName
    }
  }
  
  var timePublishedArticleName: String!{
    didSet{
    
      let iso = ISO8601DateFormatter()
      let isoString = iso.date(from: timePublishedArticleName)
      timePublishedArticle.text = "\(isoString!)".replacingOccurrences(of: "+0000", with: "")
    }
  }
  
  func configureContent(article: Article){
    guard let urlToImage = article.urlToImage, let title = article.title, let time = article.publishedAt else {return}
    imageArticleName = urlToImage
    timePublishedArticleName = time
    titleArticleName = title
  }
}
