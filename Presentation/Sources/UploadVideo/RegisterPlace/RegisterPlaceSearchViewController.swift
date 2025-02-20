//
//  RegisterPlaceSearchViewController.swift
//  Presentation
//
//  Created by 한지석 on 1/15/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import Then

import Common

final class RegisterPlaceSearchViewController: UIViewController {

  private let searchBackgroundView = UIView()
  private let searchImageView = UIImageView()
  private let searchTextField = UITextField()
  private let tableView = UITableView()
  private let registerImageView = UIImageView()

  private let viewModel = RegisterPlaceSearchViewModel()
  private var cancellables = Set<AnyCancellable>()
  var placeRegistered: PassthroughSubject<SearchPlaceViewModel.SearchedPlace, Never>?

  override func viewDidLoad() {
    super.viewDidLoad()
    setStyle()
    setUI()
    setAutolayout()
    bindViewModel()
    setupCustomBackButton()
  }

  private func bindViewModel() {
    searchTextField.textPublisher
      .assign(to: \.searchText, on: viewModel)
      .store(in: &cancellables)

    viewModel.$searchedPlace
      .receive(on: RunLoop.main)
      .sink { [weak self] places in
        self?.registerImageView.isHidden = !places.isEmpty
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
  }

  private func setStyle() {
    title = "장소 등록"
    view.backgroundColor = CommonAsset.viskitBG.color

    searchBackgroundView.do {
      $0.backgroundColor = CommonAsset.viskitGray10.color
      $0.cornerRadius(8)
    }

    searchImageView.do {
      $0.image = CommonAsset.searchGray.image
      $0.tintColor = CommonAsset.viskitGray05.color
    }

    searchTextField.do {
      $0.font = ViskitFont.body1.font
      $0.placeholder = "장소 또는 상호명으로 입력해주세요."
      $0.tintColor = CommonAsset.viskitGray01.color
    }

    tableView.do {
      $0.backgroundColor = .clear
      $0.separatorStyle = .none
      $0.register(
        RegisterPlaceSearchCell.self,
        forCellReuseIdentifier: RegisterPlaceSearchCell.cellIdentifier
      )
      $0.delegate = self
      $0.dataSource = self
    }

    registerImageView.do {
      $0.image = CommonAsset.registerPlace.image
    }
  }
  private func setUI() {
    searchBackgroundView.addSubviews(
      searchImageView,
      searchTextField
    )
    view.addSubviews(
      searchBackgroundView,
      registerImageView,
      tableView
    )
    view.bringSubviewToFront(registerImageView)
  }
  private func setAutolayout() {
    searchBackgroundView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(4.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(52.adaptiveHeight)
    }

    searchImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20.adaptiveWidth)
      $0.size.equalTo(24.adaptiveWidth)
    }

    searchTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(searchImageView.snp.trailing).offset(8.adaptiveWidth)
      $0.trailing.equalToSuperview().offset(-8.adaptiveWidth)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBackgroundView.snp.bottom).offset(20.adaptiveHeight)
      $0.horizontalEdges.bottom.equalToSuperview()
    }

    registerImageView.snp.makeConstraints {
      $0.top.equalTo(searchBackgroundView.snp.bottom).offset(28.adaptiveHeight)
      $0.leading.equalToSuperview().offset(24.adaptiveWidth)
    }
  }

}

extension RegisterPlaceSearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return viewModel.searchedPlace.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RegisterPlaceSearchCell.cellIdentifier,
      for: indexPath
    ) as? RegisterPlaceSearchCell else {
      return UITableViewCell()
    }
    cell.configure(viewModel.searchedPlace[indexPath.row])
    return cell
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 68
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPlace = viewModel.searchedPlace[indexPath.row]
    let nextViewController = RegisterPlaceViewController(selectedPlace: selectedPlace)
    nextViewController.placeRegistered = placeRegistered
    navigationController?.pushViewController(nextViewController, animated: true)
  }
}
