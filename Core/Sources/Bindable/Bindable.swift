//
//  Bindable.swift
//  Core
//
//  Created by 송여경 on 7/14/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public class Bindable<T> {
  public var value: T {
    didSet {
      observer?(value)
    }
  }

  public var observer: ((T) -> Void)?

  public init(_ value: T) {
    self.value = value
  }

  public func bind(_ observer: @escaping (T) -> Void) {
    self.observer = observer
    observer(value)
  }
}
