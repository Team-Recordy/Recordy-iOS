//
//  RecordyProgressView.swift
//  Common
//
//  Created by Chandrala on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class RecordyProgressView: UIView {
  
  var ratio: CGFloat = 0.0 {
    didSet {
      self.isHidden = !self.ratio.isLess(than: 1.0)
      
      self.progressBarView.snp.remakeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.width.equalToSuperview().multipliedBy(self.ratio)
      }
      
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        options: .curveEaseInOut,
        animations: self.layoutIfNeeded,
        completion: nil
      )
    }
  }
  
  let progressBarView = UIView().then {
    $0.backgroundColor = CommonAsset.recordyMain.color
  }
  
  init(frame: CGRect = .zero, ratio: CGFloat = 0.0) {
    self.ratio = ratio
    super.init(frame: frame)
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setStyle() {
    self.isUserInteractionEnabled = false
    self.backgroundColor = CommonAsset.recordySub01.color
  }
  
  func setUI() {
    self.addSubview(progressBarView)
  }
  
  func setAutoLayout() {
    progressBarView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(ratio)
    }
  }
}
