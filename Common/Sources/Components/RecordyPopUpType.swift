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
  case uploadPermission
  case exit
  case signOut
  case withdraw
  case delete
  case register(place: String)

  public var image: UIImage {
    return CommonAsset.alertImage.image
  }
  
  public var backgroundColor: UIColor {
    return CommonAsset.viskitGray10.color
  }
  
  public var title: String {
    switch self {
    case .permission:
      "필수 권한을 허용해주세요"
    case .uploadPermission:
      "필수 권한을 허용해주세요"
    case .exit:
      "화면을 나가시겠어요?"
    case .signOut:
      "로그아웃 하시겠어요?"
    case .withdraw:
      "정말 탈퇴하시겠어요?"
    case .delete:
      "영상을 삭제할까요?"
    case .register(let place):
      "'\(place)'를\n등록할까요??"
    }
  }
  
  public var titleFont: UIFont {
    return ViskitFont.title3.font
  }
  
  public var subtitle: String {
    switch self {
    case .permission:
      "내 위치 기반 공간 추천을 위해\n사용자의 위치에 접근하도록 허용해주세요."
    case .uploadPermission:
      "전시회 관련 영상과 프로필 사진 업로드를 위해\n사진 라이브러리에 접근하도록 허용해주세요."
    case .exit:
      "지금까지 작성하신 내용이 모두 사라져요."
    case .signOut:
      "버튼을 누르면 로그인 페이지로 이동합니다."
    case .withdraw:
      "소중한 기록들이 모두 사라져요."
    case .delete:
      "해당 기록은 영구 삭제되며, 복구가 불가능해요"
    case .register:
      "등록할까요?"
    }
  }
  
  public var subtitleFont: UIFont {
    return ViskitFont.caption1Regular.font
  }
  
  public var buttonTitle: String {
    switch self {
    case .permission:
      "설정으로 가기"
    case .uploadPermission:
      "설정으로 가기"
    case .exit:
      "나가기"
    case .signOut:
      "로그아웃"
    case .withdraw:
      "탈퇴"
    case .delete:
      "삭제하기"
    case .register:
      "등록"
    }
  }
  
  public var buttonBackgroundColor: UIColor {
    return CommonAsset.viskitYellow400.color
  }
  
  public var buttonTitleColor: UIColor {
    return CommonAsset.viskitBlack.color
  }
  
  public var closeButtonBackgroundColor: UIColor {
    return CommonAsset.viskitGray07.color
  }
  
  public var closeButtonTitleColor: UIColor {
    return CommonAsset.viskitGray03.color
  }
  
  public var buttonFont: UIFont {
    return RecordyFont.button2.font
  }
}
