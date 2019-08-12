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
    closeSideMenuByPanEdge()
    
  }
  
  func closeSideMenuByPanEdge(){
    let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(gesture:)) )
    edgePan.edges = .right
    self.view.addGestureRecognizer(edgePan)
  }
  
  @objc func handleEdgePan(gesture: UIScreenEdgePanGestureRecognizer){
    NotificationCenter.default.post(name: NSNotification.Name("CloseSideMenyByPanEdge"), object: nil, userInfo: ["data": gesture])
    
  }
  
  @IBAction func CloseMenuByPressed(_ sender: Any) {
    NotificationCenter.default.post(name: NSNotification.Name("OpenSideMenu"), object: nil)
  }
  
  func configureMenuCollectionView(){
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
  }
}

extension SideMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ApiServices.instance.TOPIC_NEWSAPI.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellOfSideMenu", for: indexPath) as! SideMenuCell
    
    cell.imageSideMenu.image = UIImage(named: "\(ApiServices.instance.TOPIC_NEWSAPI[indexPath.row])")
    cell.topic.text = "\(ApiServices.instance.TOPIC_NEWSAPI[indexPath.row])"
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 165, height: 200)
  }
  
}
