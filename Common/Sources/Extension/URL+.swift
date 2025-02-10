//
//  URL+.swift
//  Common
//
//  Created by 송여경 on 2/10/25.
//  Copyright © 2025 com. All rights reserved.
//

import UIKit

extension URL {
  public func deletingQuery() -> String {
    return self.deletingQueryItems().absoluteString
  }
  
  public func deletingQueryItems() -> URL {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
    components?.query = nil
    return components?.url ?? self
  }
}
