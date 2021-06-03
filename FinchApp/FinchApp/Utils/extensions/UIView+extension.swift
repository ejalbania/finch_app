//
//  UIView+extension.swift
//  FinchApp
//
//  Created by Emmanuel Albania on 6/3/21.
//

import UIKit

extension UIView {
  @discardableResult
  open override func resignFirstResponder() -> Bool {
    self.subviews.forEach { _ = $0.resignFirstResponder() }
    return super.resignFirstResponder()
  }

  func subview(forAutoLayout subview: UIView) {
    self.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
  }

  func subviews(forAutoLayout subviews: UIView...) {
    self.subviews(forAutoLayout: subviews)
  }

  func subviews(forAutoLayout subviews: [UIView]) {
    subviews.forEach(self.subview)
  }

  func searchForDescendants(query: (UIView) throws -> Bool) -> [UIView] {
    guard let result: [UIView] = try? self.getDescendants().filter(query) else {
      return []
    }

    return result
  }

  func getDescendants() -> [UIView] {
    var descendants = [UIView]()

    descendants.append(self)

    self.subviews.forEach { descendants.append(contentsOf: $0.getDescendants() ) }

    return descendants
  }
}

extension UIView {
  // MARK: Properties
  var width: CGFloat { self.bounds.width }
  var height: CGFloat { self.bounds.height }

  //MARK: Setters
  @discardableResult
  func subviewOf<T: UIView>(view: T) -> Self {
    self.removeFromSuperview()
    view.subview(forAutoLayout: self)
    return self
  }

  @discardableResult
  func setAsHidden(status: Bool = true) -> Self {
    self.isHidden = status
    return self
  }
  
  @discardableResult
  func setFrame(_ rect: CGRect) -> Self {
    self.frame = rect
    return self
  }

  @discardableResult
  func set(tag: Int) -> Self {
    self.tag = tag
    return self
  }

  @discardableResult
  func setBackground(color: UIColor) -> Self {
    self.backgroundColor = color
    return self
  }

  @discardableResult
  func set(alpha: CGFloat) -> Self {
    self.alpha = alpha
    return self
  }

  @discardableResult
  func isClippedToBounds(_ status: Bool? = nil) -> Self {
    self.clipsToBounds = status ?? true
    return self
  }

  // MARK: Layer setters
  @discardableResult
  func setCorner(radius: CGFloat) -> Self {
    self.layer.cornerRadius = radius
    self.setMasksToBounds()
    return self
  }

  @discardableResult
  func setBorder(width: CGFloat) -> Self {
    self.layer.borderWidth = width
    return self
  }

  @discardableResult
  func setBorder(color: UIColor) -> Self {
    self.layer.borderColor = color.cgColor
    return self
  }

  @discardableResult
  func setRounded(corners: CACornerMask, radius: CGFloat) -> Self {
    self
      .setCorner(radius: radius)
      .layer.maskedCorners = corners
    return self
  }

  @discardableResult
  func setMasksToBounds(_ status: Bool = true) -> Self {
    self.layer.masksToBounds = status
    return self
  }

  // MARK: Shadow properties
  @discardableResult
  func addShadow(color: UIColor, with radius: CGFloat, in offset: CGSize) -> Self {
    let shadowPath = UIBezierPath(
      rect: CGRect(
        origin: .zero,
        size: CGSize(
          width: radius * 2.1,
          height: self.height
        )
      )
    )

    return self
      .setCorner(radius: 2)
      .setShadow(color: color)
      .setShadow(offset: offset)
      .setShadow(opacity: 0.5)
      .setCorner(radius: radius)
      .setMasksToBounds(false)
      .setShadow(path: shadowPath.cgPath)
  }

  @discardableResult
  func setShadow(color: UIColor) -> Self {
    self.layer.shadowColor = color.cgColor
    return self
  }

  @discardableResult
  func setShadow(offset: CGSize) -> Self {
    self.layer.shadowOffset = offset
    return self
  }

  @discardableResult
  func setShadow(opacity: Float) -> Self {
    self.layer.shadowOpacity = opacity
    return self
  }

  @discardableResult
  func setShadow(radius: CGFloat) -> Self {
    self.layer.shadowRadius = radius
    return self
  }

  @discardableResult
  func setShadow(path: CGPath) -> Self {
    self.layer.shadowPath = path
    return self
  }

  // MARK: User interacation and UI behaviours
  @discardableResult
  func setUserInteractionEnabled(_ flag: Bool = true) -> Self {
    self.isUserInteractionEnabled = flag
    return self
  }

  @discardableResult
  func addGesture(recognizer: UIGestureRecognizer) -> Self {
    self.setUserInteractionEnabled()
      .addGestureRecognizer(recognizer)
    return self
  }
}

// MARK: Customize Functions
extension UIView {
  @discardableResult
  func toRoundedCorners() -> Self {
    let diameter = self.width < self.height ?
      self.width: self.height

    self.setCorner(radius: diameter/2)

    return self
  }
}
