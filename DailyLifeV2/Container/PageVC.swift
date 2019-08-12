//
//  PageVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageVC: UIViewController, IndicatorInfoProvider {
  
  @IBOutlet var newsFeedCV: UICollectionView!
  var aricles = [Article]()
  var menuBarTitle: String = ""
  override func viewDidLoad() {
        super.viewDidLoad()
  
    newsFeedCV.delegate = self
    newsFeedCV.dataSource = self

  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "\(menuBarTitle)")
  }
}

extension PageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.aricles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PageCell
    cell.confiureCell(title: aricles[indexPath.row].title
      , timePublished: aricles[indexPath.row].publishedAt, image: aricles[indexPath.row].urlToImage)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = self.view.frame.width - 30
    return CGSize(width: width, height: width * 9 / 16 + 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
    
  }
  
  
  
}
