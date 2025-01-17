//
//  DTO+CheckNicknameResponse.swift
//  Core
//
//  Created by Chandrala on 1/17/25.
//  Copyright © 2025 com. All rights reserved.
//

import Foundation

extension DTO {
  public struct CheckNicknameResponse: BaseResponse, EmptyDecodable {

    
    public let errorCode: String?
    public let errorMessage: String?
    
    public init(
      errorCode: String?,
      errorMessage: String?
    ) {
      self.errorCode = errorCode
      self.errorMessage = errorMessage
    }
    
    init() {
      self.errorCode = nil
      self.errorMessage = nil
    }
  }
}

extension DTO.CheckNicknameResponse: Decodable {
  public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try? container.decode(String.self, forKey: .errorCode)
        errorMessage = try? container.decode(String.self, forKey: .errorMessage)
    }
}
