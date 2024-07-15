//
//  RecordyGradientNavigationBar.swift
//  Common
//
//  Created by 한지석 on 7/13/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import SnapKit
import Then

public class RecordyGradientView: UIView {

  let gradientLayer = CAGradientLayer()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
     super.layoutSubviews()
     gradientLayer.frame = self.bounds
   }

  private func setStyle() {
    let colors: [UIColor] = [
      CommonAsset.recordyMain.color.withAlphaComponent(0.2),
      .black.withAlphaComponent(0)
    ]
    gradientLayer.do {
      $0.startPoint = CGPoint(x: 0.5, y: 0.0)
      $0.endPoint = CGPoint(x: 0.5, y: 1.0)
      $0.locations = [0.0, 0.9, 1.0]
      $0.colors = colors.map { $0.cgColor }
    }
  }

  private func setUI() {
    self.layer.addSublayer(gradientLayer)
  }

}
