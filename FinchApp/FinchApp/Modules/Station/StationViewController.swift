//
//  AgencyViewController.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit
import SnapKit

class StationViewController: UIViewController {
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  
  fileprivate var viewModel: StationViewModel
  @IBOutlet weak var tableView: UITableView!
  var model:StationModel { self.viewModel.model.value  }
  
  required init(model: StationModel) {
    self.viewModel = StationViewModel(model: model)
    super.init(nibName: String(describing: Self.classForCoder()), bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUIComponents()
  }
  
  fileprivate func configureUIComponents() {
    self.titleLabel.text = self.viewModel.model.value.name
    self.configureTableView()
  }
  
  fileprivate func configureTableView() {
    self.tableView.dataSource = self
    self.tableView
      .register(
        UINib(nibName: "RouteCardCellView", bundle: nil),
        forCellReuseIdentifier: RouteCardCellView.identifier
      )
  }
  
  func reloadList() {
    UIView.animate(withDuration: 0.3) {
      self.tableView.reloadData()
      self.view.layoutIfNeeded()
    }
  }
}

extension StationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.viewModel.routeCount
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    self.viewModel.getRoutes()[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.getDistinctShapes(from: section).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RouteCardCellView.identifier) as? RouteCardCellView,
          let itinerary = self.viewModel.getDistinctShapes(from: indexPath.section)[safe: indexPath.row] else {
      return UITableViewCell()
    }
    
    return cell
      .setStop(times: itinerary)
  }
  
  
}
