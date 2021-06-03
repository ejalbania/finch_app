//
//  RouteCardCellView.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/3/21.
//

import UIKit

class RouteCardCellView: UITableViewCell {
  fileprivate(set) var route: StopTimes = StopTimes(departure_time: "", departure_timestamp: 0, shape: "")
  fileprivate(set) var origin:String = "Origin"
  fileprivate(set) var destination:String = "Destination"
  @IBOutlet weak var mainContainerView: UIView!
  @IBOutlet weak var destinationLabel: UILabel!
  @IBOutlet weak var departureContainer: UIView!
  @IBOutlet weak var departureTimeInterval: UILabel!
  
  @IBOutlet weak var originLabel: UILabel!
  static var identifier: String {
    return String(describing: self.classForCoder)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.updateContent()
  }
  
  override func layoutSubviews() {
    self.configureUIComponents()
    
  }
  
  fileprivate func configureUIComponents() {
    self.departureContainer
      .setBackground(color: .cinnabar)
      .setCorner(radius: self.departureContainer.width/2)
    
    self.mainContainerView
      .setCorner(radius: 12)
      .addShadow(
        color: .capeCod,
        with: 5,
        in: .init(width: 1, height: 1)
      )
  }
  
  func getFormattedTime() -> String {
    let interval = self.route.getDepartureSecondsFromNow()
    
    let seconds = (interval % 3600) % 60
    let minutes = (interval % 3600) / 60
    let hour = seconds / 3600

    return [ hour, minutes, seconds].map {
      "\($0.toString.count < 2 ? "0":"")\($0.toString)"
    }.joined(separator: ":")
  }
  
  func updateContent() {
    self.originLabel.text = origin
    self.destinationLabel.text = destination
    self.departureTimeInterval.text = "\(self.getFormattedTime())"
  }
}

extension RouteCardCellView {
  @discardableResult
  func setStop(times: StopTimes) -> Self {
    self.route = times
    var locations = [String]()
      
    var index = 0
    for word in self.route.shape.split(separator: " ") {
      if let loc = locations[safe: index] {
        if word.lowercased() == "to" {
          index++
        } else {
          locations[index] = "\(loc) \(word)"
        }
      } else {
        locations.append("\(word)")
        
      }
    }    
    self.origin = "\(locations.first ?? "")"
    self.destination = "\(locations.last ?? "")"
    self.updateContent()
    return self
  }
}
