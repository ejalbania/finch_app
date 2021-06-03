//
//  UIFont+extensions.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit

extension UIFont {
  static func helveticaNeueBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Helvetica Neue Bold", size: size) ?? .systemFont(ofSize: size)
  }
  
  static func helveticaNeue(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Helvetica Neue", size: size) ?? .systemFont(ofSize: size)
  }
}
