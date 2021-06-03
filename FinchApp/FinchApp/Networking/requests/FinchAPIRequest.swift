//
//  FinchAPIRequest.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/1/21.
//

import Moya

enum FinchAPIRequest {
  case station
}

extension FinchAPIRequest: TargetType {
  var baseURL: URL {
    return .MYTTC
  }
  
  var path: String {
    switch self {
    case .station: return "finch_station.json"
    }
  }
  
  var method: Method {
    switch self {
    case .station:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .station: return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return [:]
  }
  
  
}
