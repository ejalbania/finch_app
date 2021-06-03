//
//  Int+extension.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit

extension Int {
  var toColor: UIColor { return UIColor(hex: UInt64(self)) }

  var toString: String { return String(describing: self) }
}
