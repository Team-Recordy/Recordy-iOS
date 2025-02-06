//
//  VideoFeedViewController.swift
//  Presentation
//
//  Created by 한지석 on 7/6/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core
import Common

import SnapKit
import Then

@available(iOS 16.0, *)
public class VideoFeedViewController: UIViewController {

  enum Sheet {
    static let defaultHeight: CGFloat = 152
    static let expandedHeight: CGFloat = 566
    static let reasonHeight: CGFloat = 243
  }

  var collectionView: UICollectionView? = nil

  private let recordyToggle = ViskitToggle()
  var isPlayed = false
  var type: VideoFeedType
  var viewModel: VideoFeedViewModel

  public init(
    type: VideoFeedType,
    placeId: Int? = nil,
    exhibitionId: Int? = nil,
    cursorId: Int? = nil,
    userId: Int? = nil
  ) {
    self.type = type
    self.viewModel = VideoFeedViewModel(
      type: type,
      placeId: placeId,
      exhibitionId: exhibitionId,
      cursorId: cursorId,
      userId: userId
    )
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpCollectionView()
    setUI()
    setAutolayout()
  }

  public override func viewWillAppear(_ animated: Bool) {
    setStyle()
    bind()
    viewModel.recordListCase()
  }

  public override func viewDidDisappear(_ animated: Bool) {
    removeAVPlayers()
  }

  private func setStyle() {
    navigationController?.isNavigationBarHidden = type == .all || type == .follow
    view.backgroundColor = CommonAsset.recordyBG.color
    recordyToggle.do {
      $0.isHidden = type != .all && type != .follow
    }
    recordyToggle.toggleAction = { [weak self] toggleState in
      guard let self = self else { return }
      toggleButtonTapped(type: toggleState == .all ? .follow : .all)
    }
    if type != .all {
      navigationController?.navigationBar.topItem?.title = ""
    }
  }

  private func setUI() {
    view.addSubview(collectionView!)
    view.addSubview(recordyToggle)
    view.bringSubviewToFront(recordyToggle)
  }

  private func setAutolayout() {
    collectionView!.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    recordyToggle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(12.adaptiveHeight)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(124)
      $0.height.equalTo(32)
    }
  }

  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView!.showsVerticalScrollIndicator = false
    collectionView!.contentInsetAdjustmentBehavior = .never
    collectionView!.isPagingEnabled = true
    collectionView!.backgroundColor = CommonAsset.recordyBG.color
    collectionView!.register(
      FeedCell.self,
      forCellWithReuseIdentifier: FeedCell.cellIdentifier
    )
    collectionView!.delegate = self
    collectionView!.dataSource = self
  }

  private func bind() {
    viewModel.onFeedListUpdate = { [weak self] count in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.collectionView?.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          if let firstCell = self.collectionView?.cellForItem(
            at: IndexPath(row: 0, section: 0)
          ) as? FeedCell, !self.viewModel.isPlayed {
            self.viewModel.play()
            firstCell.play()
          }
        }
        //TODO: 토글 되었을 때 가능한 상황 추가적 고려 필요
//        if self.viewModel.isToggle {
//          self.isPlayed = false
//          self.collectionView!.reloadData()
//          self.viewModel.isToggle = false
//        } else {
//          let indexPaths = (self.viewModel.feedList.count - count..<self.viewModel.feedList.count).map {
//            IndexPath(item: $0, section: 0)
//          }
//          self.collectionView!.insertItems(at: indexPaths)
//        }
      }
    }
  }

  @objc func nicknameButtonTapped(_ sender: UIButton) {
    print(#function)
    guard type == .others || type == .mine else { return }
    let index = sender.tag
    let feed = viewModel.feedList[index]
    let userVC = OtherUserProfileViewController(id: feed.uploaderId)
    self.navigationController?.pushViewController(userVC, animated: true)
  }

  func toggleButtonTapped(type: VideoFeedType) {
    viewModel.toggle(from: type == .all ? .follow : .all)
  }

  func sheetAction() {
    guard let visibleIndexPath = collectionView?.indexPathsForVisibleItems.first else { return }

    let currentFeed = viewModel.feedList[visibleIndexPath.row]
    let feedId = currentFeed.id
    let isMine = currentFeed.isMine

    let nextViewController = ReportWithCopyLinkViewController(
      id: feedId,
      isMine: isMine
    )
    nextViewController.delegate = self
    let navigationController = BaseNavigationController(rootViewController: nextViewController)

    if let sheet = navigationController.sheetPresentationController {
      configureSheet(sheet, height: Sheet.defaultHeight)
    }

    present(navigationController, animated: true)
  }

  private func configureSheet(_ sheet: UISheetPresentationController, height: CGFloat) {
    sheet.detents = [.custom { _ in return height.adaptiveHeight }]
    sheet.prefersGrabberVisible = true
  }

  func updateSheetHeight(_ height: CGFloat) {
    guard let sheet = presentedViewController?.sheetPresentationController else { return }
    sheet.animateChanges {
      sheet.detents = [.custom { _ in return height.adaptiveHeight }]
    }
  }
}
