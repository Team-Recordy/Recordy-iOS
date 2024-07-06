//
//  UploadVideoViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common

import RxSwift
import RxCocoa
import SnapKit
import Then

class UploadVideoViewController: UIViewController {

  private let videoLabel = UILabel().then {
    $0.text = "영상"
    $0.font = RecordyFont.title1.font
    $0.textColor = .white
  }
  private let videoThumbnailImageView = UIImageView().then {
    $0.cornerRadius(16)
    $0.contentMode = .scaleAspectFit
  }

  private let viewModel: UploadVideoViewModel
  private let disposeBag = DisposeBag()

  init(viewModel: UploadVideoViewModel) {
    self.viewModel = viewModel
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
    bind()
  }

  private func setStyle() {
    self.view.backgroundColor = .gray
  }

  private func setUI() {
    self.view.addSubview(videoLabel)
    self.view.addSubview(videoThumbnailImageView)
  }

  private func setAutolayout() {
    self.videoLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(70.adaptiveHeight)
      $0.leading.equalToSuperview().inset(20.adaptiveWidth)
    }
    self.videoThumbnailImageView.snp.makeConstraints {
      $0.top.equalTo(videoLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.leading.equalToSuperview().inset(20.adaptiveWidth)
      $0.width.equalTo(180.adaptiveWidth)
      $0.height.equalTo(284.adaptiveHeight)
    }
  }

  func bind() {
    let output = viewModel.transform(input: UploadVideoViewModel.Input())

    output.thumbnailImage
      .drive(videoThumbnailImageView.rx.image)
      .disposed(by: disposeBag)
  }
}
