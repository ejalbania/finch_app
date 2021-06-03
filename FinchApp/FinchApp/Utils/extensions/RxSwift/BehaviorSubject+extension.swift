//
//  BehaviorSubject+extension.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import RxSwift

extension BehaviorSubject {
  var value: Element {
    return try! self.value()
  }
}
