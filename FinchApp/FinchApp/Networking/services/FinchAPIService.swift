//
//  FinchAPIService.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/1/21.
//

import RxSwift
import Moya
import SwiftyJSON

class FinchAPIService {
  fileprivate static var provider = MoyaProvider<FinchAPIRequest>()
  
  static func fetchStations() -> Observable<FinchModel> {
    return Observable.create { observer in
      _ = provider
        .rx.request(.station)
        .subscribe(onSuccess: {
          do {
            let json = try JSONDecoder().decode(FinchModel.self, from: $0.data)
            observer.onNext(json)
          } catch {
            observer.onError(error)
          }
        }, onError: {
          observer.onError($0)
        })
      return Disposables.create()
    }
  }
}

struct FinchModel: Codable {
  var time: Int
  var stops: [StationModel]
  
}

struct StationModel: Codable {
  var agency: String
  var name: String
  var routes: [RouteModel]
}

struct RouteModel: Codable {
  var name: String
  var uri: String
  var stop_times: [StopTimes]
}

struct StopTimes: Codable {
  var departure_time: String
  var departure_timestamp: Int
  var shape: String

  func getDepartureSecondsFromNow() -> Int {
    return (Date(timeIntervalSince1970: TimeInterval(self.departure_timestamp)) - Date()).second ?? 0
  }
  
}
