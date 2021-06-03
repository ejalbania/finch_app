//
//  operators.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/3/21.
//

postfix operator ++
postfix operator --

postfix func ++<Num: Numeric>(value: inout Num) {
  value = value + 1
}

postfix func --<Num: Numeric>(value: inout Num) {
  value = value - 1
}

