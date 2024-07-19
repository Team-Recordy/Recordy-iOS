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

    public init(
      nickname: String,
      termsAgreement: TermsAgreement
    ) {
      self.nickname = nickname
      self.termsAgreement = termsAgreement
    }
  }
}

extension DTO.SignUpRequest {
  public struct TermsAgreement: BaseRequest {
    public let useTerm: Bool
    public let personalInfoTerm: Bool
    public let ageTerm: Bool

    public init(
      useTerm: Bool = true,
      personalInfoTerm: Bool = true,
      ageTerm: Bool = true
    ) {
      self.useTerm = useTerm
      self.personalInfoTerm = personalInfoTerm
      self.ageTerm = ageTerm
    }
  }
}
