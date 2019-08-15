//
//  ReadingVCTest.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/14/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SDWebImage

class ReadingVCTest: UIViewController {
  
  var article: Article?
  @IBOutlet var myTextView: UITextView!
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var titleArticle: UILabel!
  @IBOutlet var authorArticle: UILabel!
  
  let seeMore = "See more"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    configureContent()
    
  }
  
 
  func configureContent(){
    guard let urlToImage = article?.urlToImage else {return}
    imageArticle.sd_setImage(with: URL(string: urlToImage), completed: nil)
    titleArticle.text = article?.title
    authorArticle.text = article?.author
    
    myTextView.delegate = self
    myTextView.layer.cornerRadius = 7
    
    let attributedOfString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)]
    
    let stringContent = "\(article!.content!)! - \(seeMore)"
    let completedConent = stringContent.replacingOccurrences(of: "[]", with: "(", options: String.CompareOptions.literal, range: nil)
    let finalContent = completedConent.replacingOccurrences(of: "]", with: ")", options: String.CompareOptions.literal, range: nil)
    let attributedString = NSMutableAttributedString(string: finalContent, attributes: attributedOfString as [NSAttributedString.Key : Any])
    
    guard let url = article?.url else {return}
    attributedString.setAsLink(textToFind: seeMore, urlString: url)
    
    myTextView.attributedText = attributedString
    
  }
}

extension ReadingVCTest:  UITextViewDelegate{
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    let webViewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    
    webViewViewController.urlOfContent = URL.absoluteString
  navigationController?.pushViewController(webViewViewController, animated: true)
    
    return false
  }
}

