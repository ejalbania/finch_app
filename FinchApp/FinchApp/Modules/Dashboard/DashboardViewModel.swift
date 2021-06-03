//
//  StationsViewModel.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/1/21.
//

import RxSwift

class DashboardViewModel {
  fileprivate var disposeBag = DisposeBag()
  fileprivate(set) var isLoading = BehaviorSubject<Bool>(value: false)
  fileprivate(set) var transits = BehaviorSubject<FinchModel?>(value: nil)
  fileprivate(set) var error: Error?
  
  var stationCount: Int {
    guard let count = try? self.transits.value()?.stops.count else {
      return 0
    }
    return count
  }
  
  func fetchStations() {
    self.isLoading.onNext(true)
    FinchAPIService.fetchStations()
      .subscribe {
        self.isLoading.onNext(false)
        self.transits.onNext($0)
      } onError: {
        self.isLoading.onNext(false)
        self.error = $0
      }.disposed(by: self.disposeBag)
  }
  
  func getStationNames() -> [String] {
    return self.transits.value?.stops.map { $0.name } ?? []
  }
  
  func getIndexOf(_ station: StationModel) -> Int? {
    return self.getStationNames()
      .firstIndex(where: {
        $0 == station.name
    })
  }
  
}
