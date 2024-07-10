//
//  SmallChipButton.swift
//  Common
//
//  Created by 송여경 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum SmallChipState{
  case active
  case deactive
}

class SmallChipButton: UIButton {
  
  var smallchipstate: SmallChipState = .deactive {
    didSet{
      updateSmallChipAppearnace()
    }
  }
  
  private let closeImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = CommonAsset.smallchipX.image
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI(){
    self.cornerRadius(15)
    titleLabel?.font = RecordyFont.caption1.font
    updateSmallChipAppearnace()
  }
  
  private func updateSmallChipAppearnace(){
    switch smallchipstate{
    case .active:
      backgroundColor = .white
      layer.borderColor = CommonAsset.recordyMain.color.cgColor
      layer.borderWidth = 1
      setTitleColor(
        CommonAsset.recordyMain.color,
        for: .normal
      )
      addCloseImageView()
      
    case .deactive:
      backgroundColor = CommonAsset.recordyGrey09.color
      setTitleColor(
        CommonAsset.recordyGrey03.color,
        for: .normal
      )
      removeCloseImageView()
    }
  }
  
  private func addCloseImageView(){
    addSubview(closeImageView)
    titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: -closeImageView.frame.width / 2,
      bottom: 0,
      right: closeImageView.frame.width / 2 + 8
    )
    
    closeImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(titleLabel!.snp.trailing)
      $0.width.height.equalTo(18.adaptiveWidth)
    }
  }
  
  private func removeCloseImageView() {
    closeImageView.removeFromSuperview()
    titleEdgeInsets = .zero
  }
}
