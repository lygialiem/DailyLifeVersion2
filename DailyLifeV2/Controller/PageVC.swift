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
  var articlesOfConcern = [Article]()
  
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    self.navigationItem.backBarButtonItem?.title = ""
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleReload), name: NSNotification.Name("reload"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleShareAction(notification:)), name: NSNotification.Name("shareAction"), object: nil)
    
  }
  @objc func handleShareAction(notification: Notification){
    let url = notification.userInfo!["data"]
    let share = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
    self.present(share, animated: true, completion: nil)
  }
  @objc func handleReload(){
    self.newsFeedCV.reloadData()
  }
  
  func configureCollectionView(){
    newsFeedCV.delegate = self
    newsFeedCV.dataSource = self
    
    //Setup UIRefreshControl:
    
    refreshControl.tintColor = #colorLiteral(red: 0.2041230202, green: 0.8423736691, blue: 0.608956933, alpha: 1)
    refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
    newsFeedCV.refreshControl = refreshControl
  }
  // Use indexOfNewArticle to insert new Article to newFeeds:
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
    cell.confiureCell(articles: (dataApi?.articles[indexPath.row])!)
    
    // check CoreData to show the state (liked - not like) of the Button Outlet:
    var flag = 0
    CoreDataServices.instance.fetchCoreData { (favoriteArticlesCD) in
      if favoriteArticlesCD == []{
        cell.likeButton.setImage(UIImage(named: "greenLikeButton"), for: .normal)
        cell.isLikedStateButton = false
      } else{
        for i in 0..<favoriteArticlesCD.count {
          if dataApi?.articles[indexPath.row].title == favoriteArticlesCD[i].titleCD{
            cell.likeButton.setImage(UIImage(named: "redLikeButton"), for: .normal)
            cell.isLikedStateButton = true
          }else {
            flag += 1
          }
          if flag > favoriteArticlesCD.count - 1{
            cell.likeButton.setImage(UIImage(named: "greenLikeButton"), for: .normal)
            cell.isLikedStateButton = false
          }
        }
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = self.view.frame.width - 40
    return CGSize(width: width, height: width * 9 / 16 + 60)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let readingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReadingVC") as! ReadingVC
    readingVC.articlesOfConcern = self.articlesOfConcern
    readingVC.articles = self.dataApi!.articles
    readingVC.indexPathOfDidSelectedArticle = indexPath
    readingVC.title = menuBarTitle
    readingVC.navigationItem.backBarButtonItem?.title = ""
    self.navigationController?.pushViewController(readingVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    if indexPath.row == dataApi!.articles.count - 1{
      let numberOfPage = 5
      if currentPage <= numberOfPage{
        ApiServices.instance.getMoreNewsApi(topic: menuBarTitle , page: currentPage, size: 20 ) { (dataApi) in
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
