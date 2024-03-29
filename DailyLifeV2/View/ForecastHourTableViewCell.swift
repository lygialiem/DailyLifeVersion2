//
//  ForecastHourTableViewCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/21/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ForecastHourTableViewCell: UITableViewCell {
  
  @IBOutlet var forecastHourlyCollectionView: UICollectionView!
  var hourlyData: HourlyDarkSkyApi?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    forecastHourlyCollectionView.delegate = self
    forecastHourlyCollectionView.dataSource = self
  }
}

extension ForecastHourTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyData?.hourly?.data?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt
    indexPath: IndexPath) -> UICollectionViewCell {
    
    let icon = hourlyData?.hourly?.data?[indexPath.row]?.icon ?? ""
    let time = Int((hourlyData?.hourly?.data?[indexPath.row]?.time ?? 0).formatEpochTime(dateFormatType: "HH"))
    
    if indexPath.row == 0{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNow", for: indexPath) as! WeatherRow1CollectionViewCell
      cell.hourNow.text = "Now"
      
      if time ?? 0 > 5 && time ?? 0 <= 17{
        DispatchQueue.main.async {
          cell.image.image = UIImage(named: "hourlyDay/\(icon)")
        }
      } else {
        DispatchQueue.main.async {
          cell.image.image = UIImage(named: "hourlyNight/\(icon)")
        }
      }
      return cell
    }else {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherRow1CollectionViewCell
      
      cell.hour.text = hourlyData?.hourly?.data?[indexPath.row]?.time?.formatEpochTime(dateFormatType: "HH")
      cell.temp.text = "\(Int(round(hourlyData?.hourly?.data?[indexPath.row]?.temperature ?? 0)))"
      if time ?? 0 > 5 && time ?? 0 <= 17{
        DispatchQueue.main.async {
          cell.image.image = UIImage(named: "hourlyDay/\(icon)")
        }
      } else {
        DispatchQueue.main.async {
          cell.image.image = UIImage(named: "hourlyNight/\(icon)")
        }
      }
      return cell
    }
  }
}
