//
//  TempVC.swift
//  Presentation
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import Lottie

public class LottieExample: UIViewController {

  public override func viewDidLoad() {
    super.viewDidLoad()
    let coreBundle = Bundle(identifier: "com.recordy.Common")

    if let filepath = coreBundle?.path(forResource: "bubble", ofType: "json") {
      let animation = LottieAnimation.filepath(filepath)
      let animationView = LottieAnimationView(animation: animation)
      animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
      animationView.center = view.center
      animationView.contentMode = .scaleAspectFit
      view.addSubview(animationView)
      animationView.play()
    } else {
      print("Lottie animation file not found.")
    }
  }

}
