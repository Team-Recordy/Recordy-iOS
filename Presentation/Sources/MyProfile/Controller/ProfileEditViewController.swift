//
//  ProfileEditViewController.swift
//  Presentation
//
//  Created by 송여경 on 10/23/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Then

class ProfileEditViewController: UIViewController {
  
  private let profileEditView = ProfileEditView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = profileEditView
  }
  
//  override func viewWillAppear(_ animated: Bool) {
////    super.viewWillAppear(animated)
////    tabBarController?.tabBar.isHidden = true
//  }
  
}
