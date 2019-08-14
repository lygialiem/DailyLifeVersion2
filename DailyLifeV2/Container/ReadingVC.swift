//
//  ReadingVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/13/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class ReadingVC: UIViewController {
  
  var article: Article?
  
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var authorArticle: UILabel!
  @IBOutlet var contenArticles: UITextView!
  
  let seeFull = "See full"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureReadingContent()
  }
  
  func  configureReadingContent(){
    
    imageArticle.sd_setImage(with: URL(string: (article?.urlToImage)!))
    authorArticle.text = article?.author
    titleArticle.text = article?.title
    
    contenArticles.delegate = self
    contenArticles.layer.cornerRadius = 10
    
    let articleString = "\(article!.content!) - \(seeFull)"
    let completedString = String(articleString.filter { !"\r\n".contains($0) })
    
    let myAttributedString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15.0)!]
    
    let attributedString = NSMutableAttributedString(string: completedString, attributes: myAttributedString as [NSAttributedString.Key : Any])
    attributedString.setAsLink(textToFind: seeFull, linkName: seeFull)
    contenArticles.attributedText = attributedString
  }
}

extension ReadingVC: UITextViewDelegate{
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    print("Hello")
    return false
  }
}

