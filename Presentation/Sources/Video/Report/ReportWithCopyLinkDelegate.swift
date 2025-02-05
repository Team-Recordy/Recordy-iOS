//
//  ReportWithCopyLinkDelegate.swift
//  Presentation
//
//  Created by 한지석 on 10/31/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

protocol ReportWithCopyLinkDelegate: AnyObject {
  func didTapReport()
  func copy()
  func cancel()
  func reason()
}
