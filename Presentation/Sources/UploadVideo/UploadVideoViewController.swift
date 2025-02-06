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

import Combine
import CombineCocoa
import SnapKit
import Then

@available(iOS 16.0, *)
public class UploadVideoViewController: UIViewController {

  private let warningLabel = UILabel()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  let videoThumbnailView = UIView()
  let videoThumbnailSelectButton = UIButton()
  let videoThumbnailAlertLabel = UILabel()
  private let videoThumbnailImageView = UIImageView()
  private let contentsTextView = RecordyTextView()
  private let placeButton = PlaceButton()
  private let displayBackgroundView = UIView()
  private let displayLabel = UILabel()
  private let displayTextField = UITextField()
  private let displayTextCountLabel = UILabel()
  let uploadButton = UIButton()
  let placeRegistered = PassthroughSubject<SearchPlaceViewModel.SearchedPlace, Never>()
  
  private let viewModel = UploadVideoViewModel()
  private var cancellables = Set<AnyCancellable>()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
    bind()
    hideKeyboard()
  }

  private func setStyle() {
    title = "영상 업로드"
    view.backgroundColor = CommonAsset.viskitBG.color

    let rightButton = UIButton(type: .system)
    rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    rightButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    navigationItem.rightBarButtonItem = rightBarButtonItem

    displayTextField.delegate = self

    scrollView.do {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
    }
    
    warningLabel.do {
      $0.text = "ⓘ 주제와 무관한 기록은 무통보로 삭제될 수 있습니다."
      $0.textColor = CommonAsset.recordyGrey03.color
      $0.font = RecordyFont.caption1.font
    }

    videoThumbnailView.do {
      $0.cornerRadius(16)
      $0.backgroundColor = CommonAsset.viskitGray10.color
    }

    videoThumbnailImageView.do {
      $0.cornerRadius(16)
      $0.contentMode = .scaleToFill
      $0.backgroundColor = CommonAsset.viskitGray10.color
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

    displayBackgroundView.do {
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.cornerRadius(8)
    }

    displayLabel.do {
      $0.text = "전시명"
      $0.font = ViskitFont.body2.font
      $0.textColor = CommonAsset.viskitGray01.color
    }

    displayTextField.do {
      $0.placeholder = "전시명을 입력해 주세요."
      $0.font = ViskitFont.body2.font
      $0.textColor = CommonAsset.viskitGray01.color
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.textAlignment = .right
    }

    displayTextCountLabel.do {
      $0.font = RecordyFont.caption2.font
      $0.textColor = CommonAsset.viskitGray05.color
      $0.text = "0 / 20"
    }

    uploadButton.do {
      $0.setTitle("업로드", for: .normal)
      $0.backgroundColor = CommonAsset.viskitGray11.color
      $0.titleLabel?.font = RecordyFont.button1.font
      $0.titleLabel?.textColor = CommonAsset.viskitGray08.color
      $0.cornerRadius(12)
    }
  }

  private func setUI() {
    view.addSubviews(
      scrollView
    )
    scrollView.addSubview(contentView)
    videoThumbnailView.addSubviews(
      videoThumbnailImageView,
      videoThumbnailSelectButton,
      videoThumbnailAlertLabel
    )
    displayBackgroundView.addSubviews(
      displayLabel,
      displayTextField
    )
    contentView.addSubviews(
      warningLabel,
      videoThumbnailView,
      contentsTextView,
      placeButton,
      displayBackgroundView,
      displayTextCountLabel,
      uploadButton
    )
  }

  private func setAutolayout() {
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
      $0.top.equalTo(contentView.snp.top).offset(8.adaptiveHeight)
      $0.centerX.equalTo(contentView.snp.centerX)
      $0.height.equalTo(18.adaptiveHeight)
    }

    videoThumbnailView.snp.makeConstraints {
      $0.top.equalTo(warningLabel.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(162.adaptiveWidth)
      $0.height.equalTo(288.adaptiveHeight)
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

    contentsTextView.snp.makeConstraints {
      $0.top.equalTo(videoThumbnailView.snp.bottom).offset(24.adaptiveHeight)
      $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20.adaptiveWidth)
      $0.height.greaterThanOrEqualTo(106.adaptiveHeight)
    }

    placeButton.snp.makeConstraints {
      $0.top.equalTo(contentsTextView.snp.bottom).offset(16.adaptiveHeight)
      $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }

    displayBackgroundView.snp.makeConstraints {
      $0.top.equalTo(placeButton.snp.bottom).offset(16.adaptiveHeight)
      $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges).inset(20.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }

    displayLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(18.adaptiveWidth)
      $0.trailing.equalTo(displayTextField.snp.leading).offset(-8.adaptiveWidth)
    }

    displayTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-18.adaptiveWidth)
    }

    displayTextCountLabel.snp.makeConstraints {
      $0.top.equalTo(displayBackgroundView.snp.bottom).offset(8.adaptiveHeight)
      $0.trailing.equalToSuperview().offset(-20.adaptiveWidth)
    }

    uploadButton.snp.makeConstraints {
      $0.top.equalTo(displayTextCountLabel.snp.bottom).offset(22.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(54.adaptiveHeight)
      $0.bottom.equalToSuperview().offset(-14.adaptiveHeight)
    }
  }

  private func bind() {
    viewModel.$thumbnailImage
      .receive(on: DispatchQueue.main)
      .assign(to: \.image, on: videoThumbnailImageView)
      .store(in: &cancellables)

//    viewModel.$contentsTextCount
//      .receive(on: DispatchQueue.main)
//      .map { Optional($0) }
//      .assign(to: \.text, on: contentsTextView.textCountLabel)
//      .store(in: &cancellables)

    viewModel.$uploadEnabled
      .receive(on: DispatchQueue.main)
      .sink { [weak self] enabled in
        self?.updateUploadButton(enabled: enabled)
      }
      .store(in: &cancellables)

    viewModel.$thumbnailImage
      .receive(on: DispatchQueue.main)
      .map { $0 != nil }
      .sink { [weak self] selected in
        self?.updateVideoSelectionState(selected: selected)
      }
      .store(in: &cancellables)

    viewModel.$place
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .sink { [weak self] place in
        self?.placeButton.configure(text: place.name)
      }
      .store(in: &cancellables)
    
    contentsTextView.textView.textPublisher
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .map { $0.count > 300 ? String($0.prefix(300)) : $0 }
      .sink { [weak self] text in
        guard let self else { return }
        self.viewModel.contents = text
        var textCount = text.count
        if text == "공간에 대한 나의 생각을 자유롭게 적어주세요!" { textCount = 0 }
        self.contentsTextView.textCountLabel.text = "\(textCount) / 300"
      }
      .store(in: &cancellables)

    displayTextField.textPublisher
      .map { $0.count > 20 ? String($0.prefix(20)) : $0 }
      .sink { [weak self] text in
        guard let self else { return }
        self.viewModel.exhibitionName = text
        self.displayTextCountLabel.text = "\(text.count) / 20"
      }
      .store(in: &cancellables)

    videoThumbnailSelectButton.tapPublisher
      .sink { [weak self] _ in
        self?.videoThumbnailSelectButtonTapped()
      }
      .store(in: &cancellables)

    uploadButton.tapPublisher
      .sink { [weak self] _ in
        self?.uploadButtonTapped()
      }
      .store(in: &cancellables)

    placeButton.tapPublisher
      .sink { [weak self] _ in
        self?.placeButtonTapped()
      }
      .store(in: &cancellables)
    
    placeRegistered
      .receive(on: DispatchQueue.main)
      .sink { [weak self] place in
        guard let self = self else { return }
        self.viewModel.place = place
      }
      .store(in: &cancellables)
  }

  private func updateUploadButton(enabled: Bool) {
    uploadButton.isEnabled = enabled
    uploadButton.backgroundColor = enabled ? CommonAsset.viskitYellow400.color : CommonAsset.viskitGray11.color
    uploadButton.setTitleColor(
      enabled ? CommonAsset.viskitBG.color : CommonAsset.viskitGray08.color,
      for: .normal
    )
  }

  private func updateVideoSelectionState(selected: Bool) {
    videoThumbnailSelectButton.setTitle(selected ? "" : "영상 선택", for: .normal)
    videoThumbnailAlertLabel.isHidden = !selected
    videoThumbnailView.backgroundColor = selected ? .clear : CommonAsset.recordyGrey08.color
  }

  @objc func videoThumbnailSelectButtonTapped() {
    viewModel.getPhotoPermission { [weak self] access in
      guard let self = self else { return }
      if access {
        DispatchQueue.main.async {
          let selectVideoViewController = SelectVideoViewController()
          selectVideoViewController.delegate = self
          let navigationController = BaseNavigationController(rootViewController: selectVideoViewController)
          navigationController.modalPresentationStyle = .fullScreen
          self.present(navigationController, animated: true)
        }
      } else {
        DispatchQueue.main.async {
          self.showPopUp(type: .permission) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
          }
        }
      }
    }
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

  @objc func placeButtonTapped() {
    let nextViewController = SearchPlaceViewController()
    nextViewController.delegate = self
    navigationController?.pushViewController(nextViewController, animated: true)
  }
}

@available(iOS 16.0, *)
extension UploadVideoViewController: UITextFieldDelegate {
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text ?? ""
    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

    return newText.count <= 20
  }

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    displayTextCountLabel.textColor = CommonAsset.viskitGray01.color
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" {
      displayTextCountLabel.textColor = CommonAsset.viskitGray05.color
    } else {
      displayTextCountLabel.textColor = CommonAsset.viskitGray01.color
    }
  }
}

@available(iOS 16.0, *)
extension UploadVideoViewController: SelectVideoDelegate {
  func selectVideo(_ data: PHAsset) {
    viewModel.selectedAsset = data
  }
}

@available(iOS 16.0, *)
extension UploadVideoViewController: SearchPlaceDelegate {
  func didSelect(place: SearchPlaceViewModel.SearchedPlace) {
    viewModel.place = place
  }
}
