//
//  UIColor+extensions.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit

extension UIColor {
  convenience init(hex: UInt64) {
    self.init(
      red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  /**
   - Dark Shades
   */
  /// Hex: #686C74
  open class var nevada: UIColor { return 0x686C74.toColor }
  /// Hex: #3A3B3C
  open class var capeCod: UIColor { return 0x3A3B3C.toColor }

  /**
    - Blue Shade
   */
  /// Hex: #76A4BB
  open class var neptune: UIColor { return 0x76A4BB.toColor }
  /// Hex: #74A2BA
  open class var brandyRose: UIColor { return 0x74A2BA.toColor }
  
  /**
   - Red Shades
   */
  /// Hex: #E4D9DA
  open class var ebb: UIColor { return 0xE4D9DA.toColor }
  /// Hex: #E44048
  open class var cinnabar: UIColor { return 0xE44048.toColor }
    
}
