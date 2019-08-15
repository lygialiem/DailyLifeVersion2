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
