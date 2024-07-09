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
  case deactive
}

class AgreeButton: UIButton {
  
  var buttonState: AgreementButtonState = .deactive {
    didSet {
      updateButtonAppearance()
    }
  }
  
  private let checkImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
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
    
    checkImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(24)
    }
    
    titleLabel?.snp.makeConstraints { make in
      make.leading.equalTo(checkImageView.snp.trailing).offset(16)
      make.centerY.equalToSuperview()
    }
    
    updateButtonAppearance()
  }
  
  private func updateButtonAppearance() {
    switch buttonState {
    case .active:
      backgroundColor = CommonAsset.recordyGrey09.color
      checkImageView.image = CommonAsset.activateCheck.image
    case .deactive:
      backgroundColor = CommonAsset.recordyGrey09.color
      checkImageView.image = CommonAsset.deactivateCheck.image
    }
  }
}
