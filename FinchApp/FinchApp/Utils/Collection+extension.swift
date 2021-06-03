//
//  Collection+extension.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/3/21.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices.contains(index) ? self[index]: nil
  }
}
