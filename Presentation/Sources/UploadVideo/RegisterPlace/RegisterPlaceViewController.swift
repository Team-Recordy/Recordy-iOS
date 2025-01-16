//
//  RegisterPlaceViewController.swift
//  Presentation
//
//  Created by 한지석 on 1/8/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Common

class RegisterPlaceViewController: UIViewController {

  private let titleLabel = UILabel()
  private let nameView = RegisterPlaceView()
  private let addressView = RegisterPlaceView()
  private let registerButton = UIButton()
  private let selectedPlace: RegisterPlaceSearchViewModel.Place

  init(selectedPlace: RegisterPlaceSearchViewModel.Place) {
    self.selectedPlace = selectedPlace
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
  }

  private func setStyle() {
    view.backgroundColor = CommonAsset.viskitBG.color

    titleLabel.do {
      $0.text = "이 장소가 맞나요?"
      $0.font = ViskitFont.title1.font
      $0.textColor = CommonAsset.viskitGray01.color
    }

    nameView.configure(
      title: "상호명",
      subtitle: selectedPlace.name
    )

    addressView.configure(
      title: "주소",
      subtitle: selectedPlace.address
    )

    registerButton.do {
      $0.backgroundColor = CommonAsset.viskitYellow400.color
      $0.setTitle("확인", for: .normal)
      $0.cornerRadius(12)
      $0.addTarget(
        self,
        action: #selector(registerButtonTapped),
        for: .touchUpInside
      )
    }
  }

  private func setUI() {
    view.addSubviews(
      titleLabel,
      nameView,
      addressView,
      registerButton
    )
  }

  private func setAutolayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(54.adaptiveHeight)
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
    }

    nameView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(25.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(76.adaptiveHeight)
    }

    addressView.snp.makeConstraints {
      $0.top.equalTo(nameView.snp.bottom).offset(14.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(76.adaptiveHeight)
    }

    registerButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
    }
  }

  @objc func registerButtonTapped() {
    navigationController?.popViewController(animated: true)
    navigationController?.popViewController(animated: true)
  }
}
