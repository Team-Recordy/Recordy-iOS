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

protocol SelectVideoDelegate: AnyObject {
  func selectVideo(_ data: PHAsset)
}

public class SelectVideoViewController: UIViewController {

  private let gradientView = RecordyGradientView()
  private let warningLabel = UILabel().then {
    $0.text = "ⓘ 최대 1분의 1080p 영상을 올려주세요."
    $0.textColor = CommonAsset.recordyGrey03.color
    $0.font = RecordyFont.caption1.font
  }

  var collectionView: UICollectionView? = nil
  var assets: [PHAsset] = []
  var viewModel = SelectVideoViewModel()
  weak var delegate: SelectVideoDelegate?

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
    self.view.backgroundColor = CommonAsset.recordyBG.color
  }

  private func setUI() {
    self.view.addSubview(self.gradientView)
    self.view.addSubview(self.warningLabel)
    self.view.addSubview(self.collectionView!)
  }

  private func setAutoLayout() {
    self.gradientView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(400.adaptiveHeight)
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
    let input = SelectVideoViewModel.Input(
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
      ) { (row, localVideo, cell) in
        cell.bind(localVideo: localVideo)
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

extension SelectVideoViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let localVideo = viewModel.assetsRelay.value[indexPath.row]
    if localVideo.playtime.timeStringToSeconds() <= 15 {
      delegate?.selectVideo(localVideo.asset)
      self.dismiss(animated: true)
    } else {
      self.showToast(status: .warning, message: "기준에 맞는 영상을 선택해주세요.", height: 44)
    }
  }

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
