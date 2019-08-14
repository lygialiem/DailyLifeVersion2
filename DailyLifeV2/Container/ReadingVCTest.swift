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
  
  let seeFull = "See full"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    configureContent()
  }
  
  // Configure content UITextview.
  func configureContent(){
    guard let urlToImage = article?.urlToImage else {return}
    imageArticle.sd_setImage(with: URL(string: urlToImage), completed: nil)
    titleArticle.text = article?.title
    authorArticle.text = article?.author
    
    myTextView.delegate = self //Error is here: khi thêm dòng nay vào thì báo lỗi và ngược lại. Nếu không dùng attributedString thì chạy bình thường dù vẫn có myTextView.delegate = self.
    
    let attributedOfString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)]
    
    let stringContent = "\(article!.content!)! - \(seeFull)"
    let attributedString = NSMutableAttributedString(string: stringContent, attributes: attributedOfString as [NSAttributedString.Key : Any])
    attributedString.setAsLink(textToFind: seeFull, linkName: seeFull)
    
    myTextView.attributedText = attributedString
    //
  }
}

extension ReadingVCTest:  UITextViewDelegate{
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    //Action when Users click to "See full":
    print("Did select Hyperlink")
    //
    return false
  }
}

