//
//  AgreeButton.swift
//  Common
//
//  Created by 송여경 on 7/8/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum AgreementButtonState {
  case active
  case inactive
}

public final class AgreeToggleButton: UIButton {
  
  var checkImageView = UIImageView().then {
    $0.image = CommonAsset.deactivateCheck.image
    $0.contentMode = .scaleAspectFit
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.backgroundColor = .clear
  }
  
  func setUI() {
    self.addSubview(checkImageView)
  }
}
