//
//  Divider.swift
//  Presentation
//
//  Created by 송여경 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public final class Divider: UIView {

  public init(color: UIColor) {
    super.init(frame: .zero)
    self.backgroundColor = color
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
