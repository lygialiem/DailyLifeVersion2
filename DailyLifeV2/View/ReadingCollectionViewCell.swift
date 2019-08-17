//
//  ReadingCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/15/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

protocol ReadingCollectionViewCellDelegate{
  func movoWebViewController(url: String)
}

class ReadingCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var myTableView: UITableView!
  
  var delegate: ReadingCollectionViewCellDelegate?
  var article: Article?
  var articlesOfConcern = [Article]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupMyTableView()
    
  }
  
  func setupMyTableView(){
    
    myTableView.delegate = self
    myTableView.dataSource = self
    myTableView.estimatedRowHeight = 400
    myTableView.rowHeight = UITableView.automaticDimension
  }
}

extension ReadingCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0{
      return 1
    } else if section == 1{
      return articlesOfConcern.count
    }
    return Int()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! FirstCell
      cell.configureContent(article: article)
      
      return cell
    } else if indexPath.section == 1{
      let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath) as! SecondCell
      cell.configureContent(article: articlesOfConcern[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1{
      return 100
    } else if indexPath.section == 0{
      return  UITableView.automaticDimension
    }
    return CGFloat()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section{
    case 0:
      return ""
    case 1:
      return "Concerned Article"
    default:
      break
    }
    return String()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1{
      delegate?.movoWebViewController(url: articlesOfConcern[indexPath.row].url!)
   
    }
  }
}



