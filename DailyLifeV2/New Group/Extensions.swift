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
    UIView.animate(withDuration: 1.5,
                   delay:0.0,
                   options:[.curveEaseInOut, .autoreverse, .repeat],
                   animations: { self.alpha = 0 },
                   completion: nil)
  }
  
  func stopBlink() {
    layer.removeAllAnimations()
    alpha = 1
  }
}

public extension Array where Element: Hashable {
  
  /// Return the array with all duplicates removed.
  ///
  /// i.e. `[ 1, 2, 3, 1, 2 ].uniqued() == [ 1, 2, 3 ]`
  ///
  /// - note: Taken from stackoverflow.com/a/46354989/3141234, as
  ///         per @Alexander's comment.
  func uniqued() -> [Element] {
    var seen = Set<Element>()
    return self.filter { seen.insert($0).inserted }
  }
}
