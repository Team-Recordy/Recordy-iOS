//
//  APITarget+Preference.swift
//  Core
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya

extension APITarget {
  public enum Preference {
    case getPreference
  }
}

extension APITarget.Preference: TargetType {
  public var baseURL: URL {
    return URL(string: BaseURL.string + "/preference")!
  }
  
  public var path: String {
    return ""
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Moya.Task {
    return .requestPlain
  }
  
  public var headers: [String : String]? {
    return .none
  }
}
