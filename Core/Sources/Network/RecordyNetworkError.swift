//
//  NetworkError.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public enum RecordyNetworkError: Error {
  case requestFailed(String)
  case decodingFailed(String)
  case invalidStatusCode(Int)
  case serverError(String)
  case unknownError

  case kakao
  case apple
}
