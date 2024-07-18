//
//  UploadVideoViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos
import UIKit

import Core
import Common

import RxSwift
import RxCocoa

/// 시스템 권한을 이 뷰모델에서 판단하여야 함
final class UploadVideoViewModel {

  struct Input {
    let selectedAsset = BehaviorRelay<PHAsset?>(value: nil)
    let selectedKeywords = BehaviorRelay<[Keyword]>(value: [])
    let location = BehaviorRelay<String>(value: "")
    let contents = BehaviorRelay<String>(value: "")
    let videoUrl = BehaviorRelay<String?>(value: nil)
    let thumbnailUrl = BehaviorRelay<String?>(value: nil)
  }

  struct Output {
    let thumbnailImage = BehaviorRelay<UIImage?>(value: nil)
    let locationTextCount = BehaviorRelay<String>(value: "0 / 20")
    let contentsTextCount = BehaviorRelay<String>(value: "0 / 300")
    let uploadEnabled = BehaviorRelay<Bool>(value: false)
    let uploadVideo = BehaviorRelay<PHAsset?>(value: nil)
  }

  private let disposeBag = DisposeBag()
  let input = Input()
  let output = Output()

  init() {
    self.bind()
    print("@Log - \(KeychainManager.shared.read(token: .AccessToken))")
    var encodedKeywords: [String] = []
    for i in 0..<encodedKeywords.count {
      let decodedData = Data(base64Encoded: encodedKeywords[i])
      if let decode = String(data: decodedData!, encoding: .utf8) {
          print("@Log decode - \(decode)")
      }
    }
  }

  func bind() {
    input.selectedAsset
       .compactMap { asset -> UIImage? in
         guard let asset = asset else { return nil }
         return PhotoKitManager.getAssetThumbnail(
           asset: asset,
           size: CGSize(width: 180, height: 284)
         )
       }
       .bind(to: output.thumbnailImage)
       .disposed(by: disposeBag)

    input.location
      .map { "\($0.count) / 20" }
      .bind(to: output.locationTextCount)
      .disposed(by: disposeBag)

    input.contents
      .map {
        if $0 == "공간에 대한 나의 생각을 자유롭게 적어주세요!" {
          "0 / 300"
        } else {
          "\($0.count) / 300"
        }
      }
      .bind(to: output.contentsTextCount)
      .disposed(by: disposeBag)

    Observable.combineLatest(
      input.selectedAsset,
      input.selectedKeywords,
      input.location,
      input.contents,
      input.videoUrl,
      input.thumbnailUrl
    ).map { asset, keywords, location, contents, videoUrl, thumbnailUrl in
      return asset != nil && keywords.count >= 1 && location.count > 0 && contents.count > 0 && contents != "공간에 대한 나의 생각을 자유롭게 적어주세요!" && videoUrl != nil && thumbnailUrl != nil
    }
    .bind(to: output.uploadEnabled)
    .disposed(by: disposeBag)
  }

  func uploadButtonTapped() {
    let apiProvider = APIProvider<APITarget.Records>()
    var encodedString = ""
    let titles = input.selectedKeywords.value.map { $0.title }
    let concatenatedString = titles.joined(separator: ",")
    if let data = concatenatedString.data(using: .utf8) {
        encodedString = data.base64EncodedString()
    }
    let request = DTO.CreateRecordRequest(
      location: input.location.value,
      content: input.contents.value,
      keywords: encodedString,
      fileUrl: DTO.CreateRecordRequest.FileUrl(
        videoUrl: input.videoUrl.value!,
        thumbnailUrl: input.thumbnailUrl.value!
      )
    )
    apiProvider.justRequest(.createRecord(request)) { result in
      switch result {
      case .success(let success):
        print("@Log - \(success)")
      case .failure(let failure):
        print("@Log - \(failure.localizedDescription)")
      }
    }
  }
}
