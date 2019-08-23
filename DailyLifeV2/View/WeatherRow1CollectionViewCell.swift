//
//  WeatherRow1CollectionView.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherRow1CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var hour: UILabel!
  @IBOutlet var image: UIImageView!
  @IBOutlet var temp: UILabel!
  
  @IBOutlet var hourNow: UILabel!
  @IBOutlet var imageNow: UIImageView!
  @IBOutlet var tempNow: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureCell(hourly: HourlyDarkSkyApi?){
 
  }
  
}
