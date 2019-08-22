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
    
   
//    navigationItem.titleView?.backgroundColor = .blue
    navigationItem.title = "AAAAAAA"
    
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
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath)
      cell.backgroundColor = .blue
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
      cell.backgroundColor = .red
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
      cell.backgroundColor = (indexPath.row % 2) == 0 ? .yellow : .green
      return cell
    default:
      return UITableViewCell()
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
    case 3:
      return 50
    default:
      return CGFloat()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section  == 0 {
      return 150
    } else if section == 1{
      return 200
    } else if section == 2{
      return 30
    } else if section == 3{
      return 50
    }
    return CGFloat()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Hourly"
    } else if section == 2{
      return "Daily"
    } else if section == 0 {
      return "Forecast"
    }
    return nil
  }
}
