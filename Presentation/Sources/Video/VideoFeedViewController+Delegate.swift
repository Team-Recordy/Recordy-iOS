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

  func delete(id: Int) {
    if let index = viewModel.feedList.firstIndex(where: { $0.id == id }) {
      viewModel.feedList.remove(at: index)
      collectionView!.reloadData()
    }
  }
}
