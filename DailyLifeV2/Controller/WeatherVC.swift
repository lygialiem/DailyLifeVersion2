//
//  WeatherVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/20/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
  
  @IBOutlet var weatherTableView: UITableView!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    
    self.navigationController?.navigationBar.isHidden = true
  
  }

  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  func  setupTableView(){
    
    weatherTableView.delegate = self
    weatherTableView.dataSource = self
  }
  
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return 10
    default:
      return Int()
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.section{
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
      
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      let header = tableView.dequeueReusableCell(withIdentifier: "header0")
      return header
    case 1:
      let header = tableView.dequeueReusableCell(withIdentifier: "header1") as! WeatherHeader1_2
      header.hourlyTitleHeader.text = "Hourly"
  
      return header
    case 2:
      let header = tableView.dequeueReusableCell(withIdentifier: "header2") as! WeatherHeader1_2
      header.dailyTitleHeader.text = "Daily"
      return header
    default:
      return UIView()
    }
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 0
    case 1:
      return 100
    case 2:
      return 50
    default:
      return CGFloat()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 150
    case 1:
      return 20
    case 2:
      return 20
    default:
      return CGFloat()
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section{
    case 1:
      return "Hourly"
    case 2:
      return "Daily"
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = .clear
  }
}
