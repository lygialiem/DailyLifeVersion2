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
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


      forecastHourlyCollectionView.delegate = self
      forecastHourlyCollectionView.dataSource = self
    }

}

extension ForecastHourTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
 
    return cell
  }
}
