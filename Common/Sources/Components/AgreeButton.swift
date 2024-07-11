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

class AgreeButton: UIButton {
  
  var buttonState: AgreementButtonState = .inactive {
    didSet {
      updateButtonAppearance()
    }
  }
  
  private let checkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    layer.cornerRadius = 8
    setTitle("전체동의", for: .normal)
    setTitleColor(CommonAsset.recordyGrey01.color, for: .normal)
    titleLabel?.font = RecordyFont.subtitle.font
    addSubview(checkImageView)
    bringSubviewToFront(checkImageView)
    
    checkImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    titleLabel?.snp.makeConstraints {
      $0.leading.equalTo(checkImageView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
    
    updateButtonAppearance()
  }
  
  private func updateButtonAppearance() {
    switch buttonState {
    case .active:
      backgroundColor = CommonAsset.recordyGrey09.color
      checkImageView.image = CommonAsset.activateCheck.image
    case .inactive:
      backgroundColor = CommonAsset.recordyGrey09.color
      checkImageView.image = CommonAsset.deactivateCheck.image
    }
  }
}
