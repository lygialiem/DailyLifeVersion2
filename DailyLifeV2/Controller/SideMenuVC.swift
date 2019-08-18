//
//  MenuVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 6/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
  @IBOutlet var menuCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMenuCollectionView()
    closeSideMenuByPan()
  }
  
  func closeSideMenuByPan(){
    let panEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(gesture:)))
    panEdge.edges = .right
    view.addGestureRecognizer(panEdge)
  }
  
 
  @IBAction func CloseMenuByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
  
  
  func configureMenuCollectionView(){
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
    menuCollectionView.showsVerticalScrollIndicator = false
  }
}

extension SideMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ApiServices.instance.TOPIC_NEWSAPI.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfSideMenu", for: indexPath) as! SideMenuCell
    
    cell.imageName = ApiServices.instance.TOPIC_NEWSAPI[indexPath.row]
    cell.topicName = ApiServices.instance.TOPIC_NEWSAPI[indexPath.row]
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 165, height: 200)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    NotificationCenter.default.post(name: NSNotification.Name("MoveToTopic"), object: nil, userInfo: ["data": indexPath])
    NotificationCenter.default.post(name: NSNotification.Name("OpenOrCloseSideMenu"), object: nil)
  }
}

// @objc function:
extension SideMenuVC{
  @objc func handleEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
    NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenyByEdgePan"), object: nil, userInfo: ["data": gesture])
    
  }
}
