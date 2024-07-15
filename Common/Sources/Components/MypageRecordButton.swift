//
//  MypageRecordButton.swift
//  Common
//
//  Created by 송여경 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit

import Then

public class MypageRecordButton: UIButton {
  public override init (frame: CGRect) {
    super.init(frame: frame)
    setStyle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setStyle() {
    layer.cornerRadius = 30
    titleLabel?.font = RecordyFont.button2.font
  }
}
