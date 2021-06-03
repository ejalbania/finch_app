//
//  StationViewModel.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import RxSwift

class StationViewModel {
  fileprivate(set) var model: BehaviorSubject<StationModel>
  var routeCount: Int {
    return model.value.routes.count
  }
  
  required init(model: StationModel) {
    self.model = BehaviorSubject<StationModel>(value: model)
  }
  
  func getRoutes() -> [String] {
    return self.model.value.routes
      .map { $0.name }
  }
  
  func getDistinctShapes(from index: Int) -> [StopTimes] {
    return self.model.value.routes[index].stop_times
      .filter {
        $0.getDepartureSecondsFromNow() > 0
      }
  }
}
