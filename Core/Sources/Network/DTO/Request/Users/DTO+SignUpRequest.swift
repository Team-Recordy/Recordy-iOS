//
//  DTO+SignUpRequest.swift
//  Core
//
//  Created by 한지석 on 7/15/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

extension DTO {
  public struct SignUpRequest: BaseRequest {
    public let nickname: String
    public let termsAgreement: TermsAgreement
  }
}

extension DTO.SignUpRequest {
  public struct TermsAgreement: BaseRequest {
    public let useTerm: Bool
    public let personalInfoTerm: Bool
    public let ageTerm: Bool

    public init(
      useTerm: Bool,
      personalInfoTerm: Bool,
      ageTerm: Bool
    ) {
      self.useTerm = useTerm
      self.personalInfoTerm = personalInfoTerm
      self.ageTerm = ageTerm
    }
  }
}
