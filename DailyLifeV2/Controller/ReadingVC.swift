//
//  ReadingVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class ReadingVC: UIViewController {
  
  @IBOutlet var readingCollectionView: UICollectionView!
  
  var articles = [Article]()
  var indexPathOfDidSelectedArticle: IndexPath?
  var articlesOfConcern = [Article]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupReadingCollectionView()
    NotificationCenter.default.addObserver(self, selector: #selector(handleMoveToWebViewViewController(notification:)) , name: NSNotification.Name("NavigateToWebViewVCFromFirstCell"), object: nil)

  }

  @objc func handleMoveToWebViewViewController(notification: Notification){
    let webViewController = notification.userInfo!["data"] as! WebViewController
    navigationController?.pushViewController(webViewController, animated: true)
  }
  func setupReadingCollectionView(){
    readingCollectionView.delegate = self
    readingCollectionView.dataSource = self
    readingCollectionView.isPagingEnabled = true
    readingCollectionView.scrollToItem(at: indexPathOfDidSelectedArticle!
      , at: .centeredHorizontally, animated: false)
  }
}

extension ReadingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return articles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let readingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "readingHorizoneCell", for: indexPath) as! ReadingCollectionViewCell
    
    readingCell.delegate = self
    readingCell.article = articles[indexPath.row]
    readingCell.articlesOfConcern = articlesOfConcern
    return readingCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: self.view.frame.height - 113)
  }
}

extension ReadingVC: ReadingCollectionViewCellDelegate{
  func movoWebViewController(url: String) {
    
    let webViewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    webViewViewController.urlOfContent = url
    self.navigationController?.pushViewController(webViewViewController, animated: true)
  }
}
