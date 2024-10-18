//
//  ViskitYellowButton.swift
//  Common
//
//  Created by 송여경 on 10/19/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public class ViskitYellowButton: UIButton {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    backgroundColor = CommonAsset.viskitYellow400.color
    layer.cornerRadius = 40
    titleLabel?.font = ViskitFont.body2Bold.font
    setTitleColor(.black, for: .normal)
    clipsToBounds = true
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }
}
