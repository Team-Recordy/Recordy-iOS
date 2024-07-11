//
//  SignupViewController.swift
//  Presentation
//
//  Created by Chandrala on 7/11/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public final class SignupViewController: UIViewController {
  
  var rootView = TermsView()
  
  public override func loadView() {
    self.view = rootView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutoLayout()
  }
  
  func setStyle() {
  }
  
  func setUI() {
    
  }
  
  func setAutoLayout() {
    
  }
}
