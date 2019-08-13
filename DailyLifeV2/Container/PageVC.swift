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
  var dataApi: NewsApi?
  var menuBarTitle: String = ""
  var currentPage = 2
  
  let refreshControl = UIRefreshControl()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
  }
  
  func configureCollectionView(){
    newsFeedCV.delegate = self
    newsFeedCV.dataSource = self
    
    //Setup UIRefreshControl:
    
    refreshControl.tintColor = #colorLiteral(red: 0.2041230202, green: 0.8423736691, blue: 0.608956933, alpha: 1)
    refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
    newsFeedCV.refreshControl = refreshControl
  }
  // Use flag to insert new Article to newFeeds:
  var indexOfNewArticle = 0
  @objc func handleRefreshControl(){
    ApiServices.instance.getNewsApi(topic: menuBarTitle) { (dataApi) in
      for index in 0..<dataApi.articles.count{
        if dataApi.articles[index].title != self.dataApi!.articles[index].title{
          self.dataApi!.articles.insert(dataApi.articles[index], at: self.indexOfNewArticle)
          self.indexOfNewArticle += 1
        }
      }
      DispatchQueue.main.async {
        self.newsFeedCV.reloadData()
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "\(menuBarTitle)")
  }
  
  
}

extension PageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let dataApi = dataApi else {return 0}
    return dataApi.articles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfArticles", for: indexPath) as! PageCell
    cell.confiureCell(title: dataApi!.articles[indexPath.row].title,
                      timePublished: dataApi!.articles[indexPath.row].publishedAt,
                      image: dataApi!.articles[indexPath.row].urlToImage)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = self.view.frame.width - 40
    return CGSize(width: width, height: width * 9 / 16 + 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let readingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadingVC") as! ReadingVC
    readingVC.article = self.dataApi!.articles[indexPath.row]
    self.navigationController?.pushViewController(readingVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    if indexPath.row == dataApi!.articles.count - 1{
      let numberOfPage = 5
      if currentPage <= numberOfPage{
        ApiServices.instance.getMoreNewsApi(topic: menuBarTitle , page: currentPage) { (dataApi) in
          for article in dataApi.articles{
            self.dataApi!.articles.append(article)
          }
          self.currentPage += 1
          DispatchQueue.main.async {
            self.newsFeedCV.reloadData()
          }
        }
      }
    }
  }
}
