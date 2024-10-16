//
//  UploadVideoViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit
import Photos

import Core
import Common

import RxSwift
import RxCocoa
import SnapKit
import Then

@available(iOS 16.0, *)
public class UploadVideoViewController: UIViewController {

  private let gradientView = RecordyGradientView()
  private let warningLabel = UILabel()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let videoThumbnailLabel = RecordySubtitleLabel(subtitle: "영상")
  let videoThumbnailView = UIView()
  let videoThumbnailSelectButton = UIButton()
  let videoThumbnailAlertLabel = UILabel()
  private let videoThumbnailImageView = UIImageView()
  private let selectedKeywordLabel = RecordySubtitleLabel(subtitle: "키워드")
  private let selectKeywordStackView = RecordySelectKeywordStackView()
  private let firstKeywordLabel = RecordyKeywordLabel()
  private let secondKeywordLabel = RecordyKeywordLabel()
  private let thirdKeywordLabel = RecordyKeywordLabel()
  private let locationLabel = RecordySubtitleLabel(subtitle: "위치")
  private let locationTextField = RecordyTextField(placeholder: "영상 속 위치는 어디인가요?")
  private let locationTextCountLabel = UILabel()
  private let contentsLabel = RecordySubtitleLabel(subtitle: "내용")
  private let contentsTextView = RecordyTextView()
  let uploadButton = UIButton()

  private let viewModel = UploadVideoViewModel()
  private let disposeBag = DisposeBag()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
    bind()
    hideKeyboard()
  }

  private func setStyle() {
    title = "내용 작성"
    view.backgroundColor = CommonAsset.recordyBG.color
    let rightButton = UIButton(type: .system)
    rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    rightButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    navigationItem.rightBarButtonItem = rightBarButtonItem

    scrollView.do {
      $0.backgroundColor = .clear
    }
    warningLabel.do {
      $0.text = "ⓘ 주제와 무관한 기록은 무통보로 삭제될 수 있습니다."
      $0.textColor = CommonAsset.recordyGrey03.color
      $0.font = RecordyFont.caption1.font
    }
    videoThumbnailView.do {
      $0.cornerRadius(16)
    }
    videoThumbnailImageView.do {
      $0.cornerRadius(16)
      $0.contentMode = .scaleToFill
    }
    videoThumbnailSelectButton.do {
      $0.titleLabel?.font = RecordyFont.caption1.font
      $0.titleLabel?.textColor = CommonAsset.recordyGrey01.color
      $0.addTarget(
        self,
        action: #selector(videoThumbnailSelectButtonTapped),
        for: .touchUpInside
      )
    }
    videoThumbnailAlertLabel.do {
      $0.text = "다른 영상 고르기"
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey01.color
    }
    selectKeywordStackView.keywordButton.do {
      $0.addTarget(
        self,
        action: #selector(selectedKeywordButtonTapped),
        for: .touchUpInside
      )
    }
    locationTextCountLabel.do {
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.recordyGrey04.color
    }
    uploadButton.do {
      $0.setTitle("업로드", for: .normal)
      $0.backgroundColor = CommonAsset.recordyMain.color
      $0.titleLabel?.font = RecordyFont.button1.font
      $0.titleLabel?.textColor = CommonAsset.recordyGrey09.color
      $0.cornerRadius(12)
      $0.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
    }
  }

  private func setUI() {
    view.addSubviews(
      gradientView,
      scrollView
    )
    scrollView.addSubview(contentView)
    videoThumbnailView.addSubviews(
      videoThumbnailImageView,
      videoThumbnailSelectButton,
      videoThumbnailAlertLabel
    )
    contentView.addSubviews(
      warningLabel,
      videoThumbnailLabel,
      videoThumbnailView,
      selectKeywordStackView,
      selectedKeywordLabel,
      locationLabel,
      locationTextField,
      locationTextCountLabel,
      contentsLabel,
      contentsTextView,
      uploadButton
    )
  }

  private func setAutolayout() {
    gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
    }

    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12.adaptiveHeight)
    }

    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.snp.edges)
      $0.width.equalTo(scrollView.snp.width)
      $0.height.greaterThanOrEqualToSuperview().priority(.low)
    }

    warningLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(40.adaptiveHeight)
      $0.centerX.equalTo(contentView.snp.centerX)
      $0.height.equalTo(18.adaptiveHeight)
    }

    videoThumbnailLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(70.adaptiveHeight)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.height.equalTo(28.adaptiveHeight)
    }

    videoThumbnailView.snp.makeConstraints {
      $0.top.equalTo(videoThumbnailLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.width.equalTo(180.adaptiveWidth)
      $0.height.equalTo(284.adaptiveHeight)
    }

    selectedKeywordLabel.snp.makeConstraints {
      $0.top.equalTo(videoThumbnailImageView.snp.bottom).offset(20.adaptiveHeight)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.height.equalTo(28.adaptiveHeight)
    }

    selectKeywordStackView.snp.makeConstraints {
      $0.top.equalTo(selectedKeywordLabel.snp.bottom).offset(10.adaptiveHeight)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.height.equalTo(36.adaptiveHeight)
    }

    locationLabel.snp.makeConstraints {
      $0.top.equalTo(selectKeywordStackView.snp.bottom).offset(24.adaptiveHeight)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.height.equalTo(28.adaptiveHeight)
    }

    locationTextField.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }

    locationTextCountLabel.snp.makeConstraints {
      $0.top.equalTo(locationTextField.snp.bottom).offset(8.adaptiveHeight)
      $0.trailing.equalTo(contentView.snp.trailing).offset(-20.adaptiveWidth)
      $0.height.equalTo(18.adaptiveHeight)
    }

    contentsLabel.snp.makeConstraints {
      $0.top.equalTo(locationTextCountLabel.snp.bottom)
      $0.leading.equalTo(contentView.snp.leading).offset(20.adaptiveWidth)
      $0.height.equalTo(28.adaptiveHeight)
    }
    
    contentsTextView.snp.makeConstraints {
      $0.top.equalTo(contentsLabel.snp.bottom).offset(12.adaptiveHeight)
      $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20.adaptiveWidth)
      $0.height.greaterThanOrEqualTo(174.adaptiveHeight)
    }

    uploadButton.snp.makeConstraints {
      $0.top.equalTo(contentsTextView.snp.bottom).offset(18.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(54.adaptiveHeight)
      $0.bottom.equalTo(contentView.snp.bottom).inset(82.adaptiveHeight)
    }

    videoThumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    videoThumbnailSelectButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    videoThumbnailAlertLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-16.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
  }

  func bind() {
    viewModel.output.thumbnailImage
      .bind(to: videoThumbnailImageView.rx.image)
      .disposed(by: disposeBag)

    viewModel.output.locationTextCount
      .bind(to: locationTextCountLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.contentsTextCount
      .bind(to: contentsTextView.textCountLabel.rx.text)
      .disposed(by: disposeBag)

    locationTextField.rx.text.orEmpty
      .filter { $0.count <= 20 }
      .bind(to: viewModel.input.location)
      .disposed(by: disposeBag)

    locationTextField.rx.controlEvent([.editingDidBegin])
      .map { RecordyTextFieldState.selected }
      .bind(to: locationTextField.rx.state)
      .disposed(by: disposeBag)

    locationTextField.rx.controlEvent([.editingDidEnd])
      .map { RecordyTextFieldState.unselected }
      .bind(to: locationTextField.rx.state)
      .disposed(by: disposeBag)

    contentsTextView.textView.rx.text.orEmpty
      .filter { $0.count <= 300 }
      .bind(to: viewModel.input.contents)
      .disposed(by: disposeBag)

    locationTextField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        if text.count > 20 {
          self.locationTextField.text = String(text.prefix(20))
          self.locationTextField.updateTextFieldStyle(for: .error)
        }
      })
      .disposed(by: disposeBag)

    contentsTextView.textView.rx.text.orEmpty
      .subscribe(onNext: { [weak self] text in
        if text.count > 300 {
          self?.contentsTextView.textView.text = String(text.prefix(300))
        }
      })
      .disposed(by: disposeBag)

    viewModel.output.uploadEnabled
      .bind(to: self.rx.uploadButtonEnabled)
      .disposed(by: disposeBag)

    viewModel.output.thumbnailImage
      .map { $0 != nil }
      .bind(to: self.rx.uploadVideoSelected)
      .disposed(by: disposeBag)
  }

  @objc func videoThumbnailSelectButtonTapped() {
    viewModel.getPhotoPermission { [weak self] access in
      guard let self = self else { return }
      if access {
        let selectVideoViewController = SelectVideoViewController()
        selectVideoViewController.delegate = self
        let navigationController = BaseNavigationController(rootViewController: selectVideoViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
      } else {
        DispatchQueue.main.async {
          self.showPopUp(type: .permission) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
          }
        }
      }
    }
  }

  @objc func selectedKeywordButtonTapped() {
    let filteringViewController = RecordyFilteringViewController()
    filteringViewController.delegate = self
    if let sheet = filteringViewController.sheetPresentationController {
      sheet.detents = [
        .custom { _ in
          return 495.adaptiveHeight
        }
      ]
      sheet.prefersGrabberVisible = true
    }
    self.present(filteringViewController, animated: true)
  }

  @objc func uploadButtonTapped() {
    viewModel.uploadButtonTapped()
    self.dismiss(animated: true)
  }

  @objc func closeButtonTapped() {
    self.showPopUp(type: .exit) {
      self.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }
  }
}

@available(iOS 16.0, *)
extension UploadVideoViewController: SelectVideoDelegate {
  func selectVideo(_ data: PHAsset) {
    viewModel.input.selectedAsset.accept(data)
  }
}

@available(iOS 16.0, *)
extension UploadVideoViewController: FilteringDelegate {
//  public func selectKeywords(_ keywords: [Keyword]) {
//    viewModel.input.selectedKeywords.accept(keywords)
//    selectKeywordStackView.updateKeywords(keywords: keywords)
//  }
}

@available(iOS 16.0, *)
extension Reactive where Base: UploadVideoViewController {
  var uploadButtonEnabled: Binder<Bool> {
    return Binder(self.base) { viewController, value in
      viewController.uploadButton.isEnabled = value
      viewController.uploadButton.backgroundColor = value ? CommonAsset.recordyMain.color : CommonAsset.recordyGrey08.color
      viewController.uploadButton.setTitleColor(value ? CommonAsset.recordyGrey09.color : CommonAsset.recordyGrey04.color, for: .normal)
    }
  }

  var uploadVideoSelected: Binder<Bool> {
    return Binder(self.base) { viewController, value in
      viewController.videoThumbnailSelectButton.setTitle(value ? "" : "영상 선택", for: .normal)
      viewController.videoThumbnailAlertLabel.isHidden = !value
      viewController.videoThumbnailView.backgroundColor = value ? .clear : CommonAsset.recordyGrey08.color
    }
  }
}

extension Reactive where Base: RecordyTextField {
  var state: Binder<RecordyTextFieldState> {
    return Binder(self.base) { textField, state in
      textField.updateTextFieldStyle(for: state)
    }
  }
}
