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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(moveToTopic(notification:)), name: NSNotification.Name("MoveToTopic"), object: nil)
  }
  
  func configureButtonBar() {
    settings.style.selectedBarHeight = 4
    settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0, green: 0.9222823977, blue: 0.7017730474, alpha: 1)
    settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarItemBackgroundColor = #colorLiteral(red: 0.1568458378, green: 0.1568738818, blue: 0.1568369865, alpha: 1)
    settings.style.buttonBarMinimumInteritemSpacing = 0
    settings.style.buttonBarItemFont = UIFont(name: "Helvetica Neue", size: 15)!
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
      oldCell?.label.textColor = .white
      newCell?.label.textColor = .white
    }
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    
    for i in 0..<ApiServices.instance.TOPIC_NEWSAPI.count{
      let pageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageControllerID") as! PageVC
      pageVC.menuBarTitle = ApiServices.instance.TOPIC_NEWSAPI[i]
      
      DispatchQueue.main.async {
        ApiServices.instance.getMoreNewsApi(topic: ApiServices.instance.TOPIC_NEWSAPI[i], page: 3,size: 10) { (dataApi) in
          pageVC.articlesOfConcern = dataApi.articles
        }
      }
      ApiServices.instance.getNewsApi(topic: ApiServices.instance.TOPIC_NEWSAPI[i]) {(dataApi) in
        pageVC.dataApi = dataApi
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
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
}
// Extension @obj function:
extension MainVC{
  
  @objc func moveToTopic(notification: Notification){
    let indexPath = notification.userInfo?["data"] as! IndexPath
    self.moveToViewController(at: indexPath.row, animated: false)
    
  }
}
