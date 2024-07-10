//
//  APITarget+Records.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  enum Records {
    case createRecord
    case deleteRecord
    case getUserRecordList
    case getRecordList
  }
}

extension APITarget.Records: TargetType {
  var baseURL: URL {
    return URL(string: "BASE_URL + /records")!
  }
  
  var path: String {
    switch self {
    case .createRecord:
      ""
    case .deleteRecord:
      "(recordId)"
    case .getUserRecordList:
      ""
    case .getRecordList:
      "(recordId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .createRecord:
      return .post
    case .deleteRecord:
      return .delete
    case .getUserRecordList:
      return .get
    case .getRecordList:
      return .get
    }
  }
  
  var task: Moya.Task {
    return .requestPlain
  }

  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}
