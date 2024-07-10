//
//  LoginViewController.swift
//  Common
//
//  Created by Chandrala on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
  
  var rootView = LoginView()
  
  override func loadView() {
    self.view = rootView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
}
