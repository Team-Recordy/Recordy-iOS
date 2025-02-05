//
//  APITarget+Report.swift
//  Core
//
//  Created by 한지석 on 2/6/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation
import Moya

extension APITarget {
  public enum Report {
    case postReport(DTO.PostReport)
  }
}

extension APITarget.Report: TargetType {

  public var validationType: ValidationType {
    .successCodes
  }

  public var baseURL: URL {
    return URL(string: BaseURL.string + "/report")!
  }

  public var path: String {
    return ""
  }

  public var method: Moya.Method {
    return .post
  }

  public var task: Moya.Task {
    switch self {
    case .postReport(let postReport):
      return .requestParameters(
        parameters: [
          "recordId": postReport.recordId,
          "reason": postReport.reason,
          "content": postReport.content
        ],
        encoding: JSONEncoding.default
      )
    }
  }

  public var headers: [String : String]? {
    return .none
  }
}
