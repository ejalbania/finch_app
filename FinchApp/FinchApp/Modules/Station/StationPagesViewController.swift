//
//  StationPagesViewController.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit
import RxSwift

protocol StationPagesDelegate {
  func stationPages(didSwitchTo viewController: StationViewController)
}

class StationPagesViewController: UIPageViewController {
  fileprivate var disposeBag = DisposeBag()
  fileprivate(set) var model = BehaviorSubject<FinchModel?>(value: nil)
  fileprivate var _delegate: StationPagesDelegate?
  fileprivate var pulse: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dataSource = self
    self.delegate = self
    self.configureCallback()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.pulse?.fire()
  }
  
  fileprivate func configureCallback() {
    self.model
      .asObserver()
      .subscribe(onNext: { _ in
        self.reloadContent()
      }).disposed(by: self.disposeBag)
    
    self.pulse = Timer.scheduledTimer(
      withTimeInterval: 0.5,
      repeats: true, block: { _ in
        (self.viewControllers?.first as? StationViewController)?.reloadList()
      })
  }
  
  fileprivate func reloadContent() {
    if let model = getModel(from: nil, to: .forward) {
      let vc = StationViewController(model: model)
      self.setViewControllers([vc], direction: .forward, animated: true)
    }
  }
  
  fileprivate func getModel(from current: StationModel?, to direction: DirectionFlow) -> StationModel? {
    if let current = current {
      guard let finchModel = self.model.value,
            let currentIndex = finchModel.stops.firstIndex(where: { $0.name == current.name }),
            let newModel = finchModel.stops[safe: (direction == .forward ? 1: -1) + currentIndex] else {
        return nil
      }
      return newModel
    } else {
      return model.value?.stops.first
    }
  }
}

extension StationPagesViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let stationVC = viewController as? StationViewController,
          let newModel = self.getModel(from: stationVC.model, to: .backward) else {
      return nil
    }
    return StationViewController(model: newModel)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let stationVC = viewController as? StationViewController,
          let newModel = self.getModel(from: stationVC.model, to: .forward) else {
      return nil
    }
    return StationViewController(model: newModel)
  }
}

extension StationPagesViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let currentVC = pageViewController.viewControllers?.first as? StationViewController {
      self._delegate?.stationPages(didSwitchTo: currentVC)
    }
  }
  
  override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
    super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
  }
}

extension StationPagesViewController {
  fileprivate enum DirectionFlow {
    case forward
    case backward
  }
  
  @discardableResult
  func setContent(model: FinchModel) -> Self {
    self.model.onNext(model)
    return self
  }
  
  @discardableResult
  func set(delegate: StationPagesDelegate) -> Self {
    self._delegate = delegate
    return self
  }
  
  func setCurrentModel(index: Int) {
    guard let currentVC = self.viewControllers?.first as? StationViewController,
          let currentIndex = self.model.value?.stops.firstIndex(where: { currentVC.model.name == $0.name }) ,
      let model = self.model.value?.stops[safe: index] else {
      return
    }
    
    let vc = StationViewController(model: model)
    let direction: NavigationDirection = currentIndex > index ? .forward: .reverse
    self.setViewControllers([vc], direction: direction, animated: true)
  }
}
