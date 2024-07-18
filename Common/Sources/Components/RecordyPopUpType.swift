//
//  RecordyPopUpType.swift
//  Common
//
//  Created by 송여경 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import UIKit

public enum RecordyPopUpType {
  case permission
  case exit
  case signOut
  case withdraw
  case delete
  
  public var image: UIImage {
    switch self {
    case .permission:
      return CommonAsset.permission.image
    case .exit:
      return CommonAsset.exit.image
    case .signOut:
      return CommonAsset.alert.image
    case .withdraw:
      return CommonAsset.alert.image
    case .delete:
      return CommonAsset.alert.image
    }
  }
  
  public var backgroundColor: UIColor {
    return CommonAsset.recordyGrey08.color
  }
  
  public var title: String {
    switch self {
    case .permission:
      "필수 권한을 허용해주세요"
    case .exit:
      "화면을 나가시겠어요?"
    case .signOut:
      "로그아웃 하시겠어요?"
    case .withdraw:
      "정말 탈퇴하시겠어요?"
    case .delete:
      "삭제하시겠어요?"
    }
  }
  
  public var titleFont: UIFont {
    return RecordyFont.title3.font
  }
  
  public var subtitle: String {
    switch self {
    case .permission:
      "사진 접근을 허용하여 영상을 업로드 하세요."
    case .exit:
      "지금까지 작성하신 내용이 모두 사라져요."
    case .signOut:
      "버튼을 누르면 로그인 페이지로 이동합니다."
    case .withdraw:
      "소중한 기록들이 모두 사라져요."
    case .delete:
      "해당 기록은 영구 삭제되며, 복구가 불가능해요"
    }
  }
  
  public var subtitleFont: UIFont {
    return RecordyFont.caption1.font
  }
  
  public var buttonTitle: String {
    switch self {
    case .permission:
      "지금 설정"
    case .exit:
      "나가기"
    case .signOut:
      "로그아웃"
    case .withdraw:
      "탈퇴"
    case .delete:
      "삭제"
    }
  }
  
  public var buttonBackgroundColor: UIColor {
    return CommonAsset.recordyMain.color
  }
  
  public var buttonTitleColor: UIColor {
    return CommonAsset.recordyGrey09.color
  }
  
  public var closeButtonBackgroundColor: UIColor {
    return CommonAsset.recordyGrey06.color
  }
  
  public var closeButtonTitleColor: UIColor {
    return CommonAsset.recordyGrey01.color
  }
  
  public var buttonFont: UIFont {
    return RecordyFont.button2.font
  }
}
