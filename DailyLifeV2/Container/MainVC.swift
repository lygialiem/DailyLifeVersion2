//
//  MainVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainVC: ButtonBarPagerTabStripViewController {
  var pageVCArray = [PageVC]()
  override func viewDidLoad() {
    configureButtonBar()
    super.viewDidLoad()
    
  }
  
  func configureButtonBar() {
    settings.style.selectedBarHeight = 4
    settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0, green: 0.9222823977, blue: 0.7017730474, alpha: 1)
    settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    settings.style.buttonBarMinimumInteritemSpacing = 0
    settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15)
    settings.style.buttonBarItemTitleColor = .red
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarHeight = 30
    settings.style.selectedBarVerticalAlignment = .bottom
    
    // Changing item text color on swipe
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .gray
      newCell?.label.textColor = .white
    }
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    
    for i in 0..<ApiServices.instance.TOPIC_NEWSAPI.count{
      let pageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerID") as! PageVC
      pageVC.menuBarTitle = ApiServices.instance.TOPIC_NEWSAPI[i]
      ApiServices.instance.getNewsApi(topic: ApiServices.instance.TOPIC_NEWSAPI[i]) {(dataApi) in
        pageVC.aricles = dataApi.articles
        
        if i == 0 {
          DispatchQueue.main.async {
            pageVC.newsFeedCV.reloadData()
          }
        }
      }
      pageVCArray.append(pageVC)
    }
    return pageVCArray
  }
  
  @IBAction func openMenuPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
  }
}
