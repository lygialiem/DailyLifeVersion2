//
//  Extensions.swift
//  DailyLifeV2
//
//  Created by Lý Gia Liêm on 8/14/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
  func setAsLink(textToFind:String, urlString: String) {
    let foundRange = self.mutableString.range(of: textToFind)
    self.addAttribute(NSAttributedString.Key.link, value: urlString, range: foundRange)
  }
}

extension UILabel {
  
  func startBlink() {
    UIView.animate(withDuration: 0.8,
                   delay:0.0,
                   options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                   animations: { self.alpha = 0 },
                   completion: nil)
  }
  
  func stopBlink() {
    layer.removeAllAnimations()
    alpha = 1
  }
}
