//
//  BaseURL.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

enum BaseURL {
  static let string: String = Bundle.main.infoDictionary?["BASE_URL"] as! String
}
