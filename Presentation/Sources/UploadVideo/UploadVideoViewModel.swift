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
  let apiProvider = APIProvider<APITarget.Records>()

  init() {
    self.bind()
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
      input.contents
    ).map { asset, keywords, location, contents in
      return asset != nil && keywords.count >= 1 && location.count > 0 && contents.count > 0 && contents != "공간에 대한 나의 생각을 자유롭게 적어주세요!"
    }
    .bind(to: output.uploadEnabled)
    .disposed(by: disposeBag)
  }

  func getPhotoPermission(completionHandler: @escaping (Bool) -> Void) {
    guard PHPhotoLibrary.authorizationStatus() != .authorized else {
      completionHandler(true)
      return
    }
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      switch status {
      case .authorized, .limited:
        completionHandler(true)
      default:
        completionHandler(false)
      }
    }
  }

  func uploadButtonTapped() {
    guard let asset = input.selectedAsset.value else { return }

    let thumbnailData = PhotoKitManager.getAssetThumbnailData(asset: asset)
    let dispatchGroup = DispatchGroup()
    var videoUrl: String?
    var thumbnailUrl: String?
    var uploadError: Error?

    PhotoKitManager.getData(of: asset) { [weak self] binaryData in
      guard let self = self else { return }
      self.apiProvider.requestResponsable(
        .getPresignedUrl,
        DTO.GetPresignedUrlResponse.self
      ) { result in
        switch result {
        case .success(let response):
          dispatchGroup.enter()
          AWSS3Uploader.upload(
            binaryData!,
            toPresignedURL: URL(string: response.videoUrl)!
          ) { result in
            switch result {
            case .success(let success):
              videoUrl = success?.removeQueryParameters()
            case .failure(let failure):
              uploadError = failure
            }
            dispatchGroup.leave()
          }

          dispatchGroup.enter()
          AWSS3Uploader.upload(
            thumbnailData!,
            toPresignedURL: URL(string: response.thumbnailUrl)!
          ) { result in
            switch result {
            case .success(let success):
              thumbnailUrl = success?.removeQueryParameters()
            case .failure(let failure):
              uploadError = failure
            }
            dispatchGroup.leave()
          }

          dispatchGroup.notify(queue: .global()) {
            guard uploadError == nil, videoUrl != nil, thumbnailUrl != nil else {
              NotificationCenter.default.post(
                name: .updateDidComplete,
                object: nil,
                userInfo: ["message": "업로드에 실패했어요!", "state": "failure"]
              )
              return
            }
            self.createRecord(videoUrl: videoUrl!, thumbnailUrl: thumbnailUrl!)
          }

        case .failure(let failure):
          print(failure)
        }
      }
    }
  }

  private func createRecord(
    videoUrl: String,
    thumbnailUrl: String
  ) {
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
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl
      )
    )
    apiProvider.justRequest(.createRecord(request)) { result in
      switch result {
      case .success(let success):
        NotificationCenter.default.post(
          name: .updateDidComplete,
          object: nil,
          userInfo: ["message": "업로드가 완료되었어요!", "state": "success"]
        )
      case .failure(let failure):
        NotificationCenter.default.post(
          name: .updateDidComplete,
          object: nil,
          userInfo: ["message": "업로드가 완료되었어요!", "state": "failure"]
        )
      }
    }
  }
}
