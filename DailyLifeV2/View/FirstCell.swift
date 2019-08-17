//
//  ReadingTableViewCell.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/17/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

protocol ReadingCellDelegate{
  func didPressSeeMore(url: String)
}

class FirstCell: UITableViewCell {
  
  
  @IBOutlet var myTextView: UITextView!
  @IBOutlet var imageArticle: UIImageView!
  @IBOutlet var authorArticle: UILabel!
  @IBOutlet var titleArticle: UILabel!
  
  var article: Article?
  var indexPathOfDidSelectedArticle: IndexPath?
  
  let seeMore = "See more"
  var delegate: ReadingCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = UITableViewCell.SelectionStyle.none
  }
  
  func configureContent(article: Article?){

    guard let urlToImage = article?.urlToImage else {return}
    imageArticle.sd_setImage(with: URL(string: urlToImage), completed: nil)
    titleArticle.text = article?.title?.capitalized
    authorArticle.text = article?.author
 
    myTextView.layer.cornerRadius = 7
    myTextView.delegate = self
    
    let attributedOfString = [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)]
    
    let stringContent = "\(article!.content!)! - \(seeMore)"
    let completedConent = stringContent.replacingOccurrences(of: "[", with: "(", options: String.CompareOptions.literal, range: nil)
    let completedConent1 = completedConent.replacingOccurrences(of: "+", with: "", options: String.CompareOptions.literal, range: nil)
    let completedConent2 = completedConent1.replacingOccurrences(of: "!", with: "", options: String.CompareOptions.literal, range: nil)
    let finalContent = completedConent2.replacingOccurrences(of: "]", with: ")", options: String.CompareOptions.literal, range: nil)
    let attributedString = NSMutableAttributedString(string: finalContent, attributes: attributedOfString as [NSAttributedString.Key : Any])
    
    guard let url = article?.url else {return}
    attributedString.setAsLink(textToFind: seeMore, urlString: url)
    
    myTextView.attributedText = attributedString
    
  }
}

extension FirstCell:  UITextViewDelegate{
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    
    delegate?.didPressSeeMore(url: URL.absoluteString)
    
    return false
  }
}


