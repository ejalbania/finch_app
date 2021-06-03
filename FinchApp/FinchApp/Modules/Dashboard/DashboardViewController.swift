//
//  ViewController.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/1/21.
//

import UIKit
import RxSwift
import NVActivityIndicatorView
import SnapKit

class DashboardViewController: UIViewController, NVActivityIndicatorViewable {
  fileprivate var disposeBag = DisposeBag()
  fileprivate var viewModel = DashboardViewModel()
  
  @IBOutlet weak var stationContainerView: UIView!
  fileprivate var stationPagesViewController: StationPagesViewController?
  @IBOutlet fileprivate var stationScrollView: UIScrollView!
  @IBOutlet fileprivate var stationListContainerView: UIView!
  @IBOutlet fileprivate var footerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUIComponents()
    self.configureCallbacks()
    self.fetchData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.configureConstraints()
  }
  
  fileprivate func fetchData() {
    self.viewModel.fetchStations()
  }
  
  fileprivate func configureCallbacks() {
    self.viewModel.isLoading
      .asObserver()
      .subscribe( onNext: {
        $0 ? self.startAnimating(): self.stopAnimating()
      }).disposed(by: self.disposeBag)
    
    self.viewModel.transits
      .asObserver()
      .subscribe( onNext: { _ in
        self.refreshDashboard()
      }).disposed(by: self.disposeBag)
  }
  
  fileprivate func setupUIComponents() {
    self.setupNavigationBar()
    
    self.stationContainerView.isClippedToBounds(false)
    
    self.stationScrollView = UIScrollView()
    self.stationScrollView.delegate = self
    self.stationScrollView.showsHorizontalScrollIndicator = false
    
    self.stationListContainerView = UIView()
        
    self.footerView.addSubview(self.stationScrollView)
    self.stationScrollView.addSubview(self.stationListContainerView)
    
  }
  
  fileprivate func configureConstraints() {
    self.stationScrollView.snp.remakeConstraints {
      $0.centerY.height.right.left.equalToSuperview()
    }
    
    self.stationListContainerView.snp.remakeConstraints {
      $0.height.centerY.equalTo(self.footerView)
      $0.leading.trailing.equalTo(self.stationScrollView)
    }
    

  }
  
  fileprivate func setupNavigationBar() {
    self.title = "Finch Bus Station"
    
    self.navigationController?.isNavigationBarHidden = true
  }
  
  fileprivate func refreshDashboard() {
    self.stationContainerView.subviews.forEach { $0.removeFromSuperview() }
    self.configureStationList()
    
    self.performSegue(withIdentifier: "sendFinchModel", sender: self)
  }
  
  fileprivate func configureStationList() {
    self.stationListContainerView.subviews.forEach { $0.removeFromSuperview() }

    let titleCards = self.viewModel.getStationNames().map { return TitleCardView($0) }
    var preView: UIView?
    
    for (index, view) in titleCards.enumerated() {
      self.stationListContainerView.addSubview(view)
      view.tag = index
      view.setTapAction{
        self.stationPagesViewController?.setCurrentModel(index: $0)
      }.snp.remakeConstraints {
        $0.centerY.equalToSuperview()
        $0.height.equalToSuperview().multipliedBy(0.8)
        $0.width.lessThanOrEqualTo(170)
        
        if let preview = preView {
          $0.leading.equalTo(preview.snp.trailing).offset(8.0)
        } else {
          $0.leading.equalToSuperview().offset(12)
        }

        if index == titleCards.count - 1 {
          $0.trailing.equalToSuperview().offset(-12)
        } else {
          preView = view
        }
      }
    }
  }
  
  fileprivate func updateSelectionIndicator(to model: StationModel, index: Int) {
    self.stationListContainerView.subviews.forEach { card in
      (card as? TitleCardView)?.setSelected(card.tag == index)
      
      if card.tag == index {
        let xLoc = card.center.x - (self.view.bounds.size.width / 2)
        self.stationScrollView.setContentOffset(.init(x: xLoc, y: 0), animated: true)
      }
    }
  }
  
  @IBAction
  fileprivate func didTapRefresh(_ sender: UIBarButtonItem) {
    if let isLoading = try? self.viewModel.isLoading.value(),
       !isLoading {
      self.fetchData()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.destination {
    case let destination as StationPagesViewController:
      if let transits = self.viewModel.transits.value {
        destination.setContent(model: transits)        
          .set(delegate: self)
      }
    default:
      return
    }
    
  }
}

extension DashboardViewController: StationPagesDelegate {
  func stationPages(didSwitchTo viewController: StationViewController) {
    if let index = self.viewModel.getIndexOf(viewController.model) {
      self.updateSelectionIndicator(to: viewController.model, index: index)
    } else {
      self.fetchData()
    }
  }
}

extension DashboardViewController: UIScrollViewDelegate {
  
}
