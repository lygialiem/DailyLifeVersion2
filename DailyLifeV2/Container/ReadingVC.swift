//
//  ReadingVC.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/13/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class ReadingVC: UIViewController, UITextViewDelegate {
  
  var article: Article?
  
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var contentArticle: UITextView!
  @IBOutlet var authorArticle: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureReadingContent()
    
    
    
  }
  
  func  configureReadingContent(){
    
    imageArticle.sd_setImage(with: URL(string: (article?.urlToImage)!))
    authorArticle.text = article?.author
    titleArticle.text = article?.title
    
    contentArticle.layer.cornerRadius = 10
    let seeFull = "See full"
    
    let articleString = "\(article!.content!) \(article!.content!) \(article!.content!) \(article!.content!) \(article!.content!) \(article!.content!) \(article!.content!) \(article!.content!) - \(seeFull)"
    let resultString = String(articleString.filter { !"\r\n".contains($0) })
    
   
    let myAttributedString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15.0)!]
    
    let attributedString = NSMutableAttributedString(string: resultString, attributes: myAttributedString as [NSAttributedString.Key : Any])
    
    let numberOfCharacterMinusTheClickableString = resultString.count - seeFull.count
    print(articleString.count, numberOfCharacterMinusTheClickableString, seeFull.count)
    attributedString.addAttribute(.link, value: "\(article!.url!)", range: NSRange(location: numberOfCharacterMinusTheClickableString, length: seeFull.count))
    contentArticle.attributedText = attributedString
   
  }
  
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    UIApplication.shared.open(URL)
    return false
  }
}
