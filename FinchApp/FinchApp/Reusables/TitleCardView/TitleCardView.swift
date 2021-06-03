//
//  TitleCardView.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/2/21.
//

import UIKit
import SnapKit

class TitleCardView: UIView {
  let title: String

  fileprivate(set) var titleLabel = UILabel()
  fileprivate(set) var tapCallback: ((Int) -> ())?
  fileprivate(set) var isSelected = false {
    didSet { self.updateColors() }
  }
  
  required init(_ title: String) {
    self.title = title
    super.init(frame: .zero)
    self.configureUIViews()
    self.configureUserInteraction()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func configureUIViews() {
    self.backgroundColor = .white
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 1
    self.layer.borderColor = .fromUIColor(.capeCod)
    
    self.titleLabel.text = self.title
    self.titleLabel.font = .helveticaNeue(16)
    self.titleLabel.textColor = .capeCod
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.numberOfLines = 0
    self.addSubview(self.titleLabel)
    
    self.titleLabel.snp.remakeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalToSuperview().multipliedBy(0.8)
    }
  }
  
  fileprivate func configureUserInteraction() {
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCard(_:))))
  }
  
  fileprivate func updateColors() {
    self.titleLabel.textColor = self.isSelected ? .white: .capeCod
    self.titleLabel.font = self.isSelected ? .helveticaNeueBold(16): .helveticaNeue(16)
    self.backgroundColor = self.isSelected ? .cinnabar: .white
  }
  
  @IBAction
  fileprivate func didTapCard(_ sender: UITapGestureRecognizer) {
    self.tapCallback?(self.tag)
  }
  
  @discardableResult
  func setTapAction(_ callback: @escaping (Int) -> ()) -> Self {
    self.tapCallback = callback
    return self
  }
  
  @discardableResult
  func setSelected(_ status: Bool) -> Self {
    self.isSelected = status
    return self
  }
}
