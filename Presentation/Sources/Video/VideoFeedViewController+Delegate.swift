//
//  VideoFeedViewController+Delegate.swift
//  Presentation
//
//  Created by 한지석 on 10/31/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

import Core

@available(iOS 16.0, *)
extension VideoFeedViewController: FeedWatchDelegate {
  func play(feed: Feed) {
    viewModel.postIsFeedWatched(feed: feed)
  }
}

@available(iOS 16.0, *)
extension VideoFeedViewController: ReportWithCopyLinkDelegate {
  func didTapReport() {
    updateSheetHeight(Sheet.expandedHeight)
  }

  func copy() {
    updateSheetHeight(Sheet.defaultHeight)
  }

  func cancel() {
    updateSheetHeight(Sheet.defaultHeight)
  }

  func reason() {
    updateSheetHeight(Sheet.reasonHeight)
  }
}
