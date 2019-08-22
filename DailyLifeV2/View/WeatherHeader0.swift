//
//  WeatherHeader0.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class WeatherHeader0: UITableViewCell {
  @IBOutlet var cityZone: UILabel!
  @IBOutlet var weatherDescription: UILabel!
  @IBOutlet var sunMoonImage: UIImageView!
  @IBOutlet var temperature: UILabel!
  @IBOutlet var currentDay: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
