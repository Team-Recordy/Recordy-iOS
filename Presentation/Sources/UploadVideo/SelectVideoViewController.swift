//
//  SelectVideoViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/2/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Common
import Photos
import PhotosUI

import SnapKit
import Then
import RxSwift
import RxRelay

public class SelectVideoViewController: UIViewController {

  private let warningLabel = UILabel().then {
    $0.text = "ⓘ 최대 1분의 1080p 영상을 올려주세요."
    $0.textColor = CommonAsset.recordyGrey03.color
    $0.font = RecordyFont.caption.font
  }
  private let nextButton = UIButton().then {
    $0.setTitle("다음", for: .normal)
    $0.titleLabel?.font = RecordyFont.button1.font
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .black
    $0.cornerRadius(12)
  }
  var collectionView: UICollectionView? = nil
  var assets: [PHAsset] = []
  var viewModel = UploadVideoViewModel()

  private let disposeBag = DisposeBag()
  private let fetchVideosRelay = PublishRelay<Void>()
  private let selectedVideoRelay = PublishRelay<IndexPath>()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setStyle()
    setUI()
    setAutoLayout()
    bind()
  }

  private func setStyle() {
    self.title = "영상 선택"
  }

  private func setUI() {
    self.view.addSubview(self.warningLabel)
    self.view.addSubview(self.collectionView!)
    self.view.addSubview(self.nextButton)
  }

  private func setAutoLayout() {
    self.nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-14.adaptiveHeight)
      $0.horizontalEdges.equalToSuperview().inset(20.adaptiveWidth)
      $0.height.equalTo(54.adaptiveHeight)
    }
    self.warningLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(9.adaptiveHeight)
      $0.centerX.equalToSuperview()
    }
    self.collectionView!.snp.makeConstraints {
      $0.top.equalTo(warningLabel.snp.bottom).offset(22.adaptiveHeight)
      $0.bottom.horizontalEdges.equalToSuperview()
    }
  }

  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    self.collectionView!.register(
      VideoCell.self,
      forCellWithReuseIdentifier: VideoCell.cellIdentifier
    )
    self.collectionView!.rx.setDelegate(self).disposed(by: disposeBag)
  }

  func bind() {
    let input = UploadVideoViewModel.Input(
      fetchVideos: fetchVideosRelay,
      selectedVideo: selectedVideoRelay
    )
    let output = viewModel.transform(input: input)

    output.asset
      .drive(
        collectionView!.rx.items(
          cellIdentifier: VideoCell.cellIdentifier,
          cellType: VideoCell.self
        )
      ) { (row, asset, cell) in
        cell.bind(asset: asset)
        cell.setSelected(
          self.viewModel.isSelected(
            indexPath: IndexPath(
              row: row,
              section: 0
            )
          )
        )
      }
      .disposed(by: disposeBag)

    output.fetchStatus
      .drive(onNext: { success in
        if !success {
          print("Permission denied")
        }
      })
      .disposed(by: disposeBag)

    collectionView!.rx.itemSelected
      .bind(to: selectedVideoRelay)
      .disposed(by: disposeBag)


    output.selectedIndexPath
      .drive { [weak self] indexPath in
        self?.collectionView!.reloadData()
      }
      .disposed(by: disposeBag)

    fetchVideosRelay.accept(())
  }
}

extension UploadVideoViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let padding: CGFloat = 4
    let width: CGFloat = (UIScreen.main.bounds.width - padding * 4) / 4
    return CGSize(
      width: width,
      height: width
    )
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 4
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 4
  }
}
