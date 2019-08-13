//
//  PageCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 7/15/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class PageCell: UICollectionViewCell {
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var timePublishedArticle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageArticle.clipsToBounds = true
    imageArticle.layer.cornerRadius = 7
    imageArticle.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    imageArticle.layer.borderWidth = 1
    
  }
  
  func confiureCell(title: String?, timePublished: String?, image: String?){
    
    guard let title = title else {return}
    self.titleArticle.text = title
    
    guard let timePublished = timePublished else {return}
    self.timePublishedArticle.text = timePublished
    
    guard let image = image else {return}
    self.imageArticle.sd_setImage(with: URL(string: image))
    
  }
}
