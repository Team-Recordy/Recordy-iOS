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
  private let currentNickname: String = "레코디"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view = profileEditView
    profileEditView.setNickname(currentNickname)
    
  }
  
}
