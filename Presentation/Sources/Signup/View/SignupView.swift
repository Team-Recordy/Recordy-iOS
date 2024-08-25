//
//  SignupView.swift
//  Presentation
//
//  Created by Chandrala on 8/12/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core
import Common

import SnapKit

class SignupView: UIView {
  
  let gradientView = RecordyGradientView()
  let progressView = RecordyProgressView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.addSubviews(
      gradientView,
      progressView
    )
  }
  
  private func setLayout() {
    progressView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(6.adaptiveHeight)
    }
    
    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }
  }
}
