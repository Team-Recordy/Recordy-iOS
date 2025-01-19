//
//  UploadVideoViewModel.swift
//  Presentation
//
//  Created by 한지석 on 7/5/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Combine
import CombineCocoa
import Photos
import UIKit

import Core
import Common


final class UploadVideoViewModel {

  // MARK: - Published Properties
  @Published var selectedAsset: PHAsset?
  @Published var contents: String = ""
  @Published var exhibitionName: String = ""
  @Published var place: SearchPlaceViewModel.SearchedPlace?

  // MARK: - Output Properties
  @Published var thumbnailImage: UIImage?
  @Published var contentsTextCount: String = "0 / 300"
  @Published var uploadEnabled: Bool = false
  @Published var uploadVideo: PHAsset?

  let apiProvider = APIProvider<APITarget.Records>()
  let awsUploader = AWSS3Uploader()
  private var cancellables = Set<AnyCancellable>()

  init() {
    self.bind()
  }

  func bind() {
    $selectedAsset
      .compactMap { asset -> UIImage? in
        guard let asset = asset else { return nil }
        return PhotoKitManager.getAssetThumbnail(
          asset: asset,
          size: CGSize(width: 180, height: 284)
        )
      }
      .assign(to: \.thumbnailImage, on: self)
      .store(in: &cancellables)

    $contents
      .map {
        if $0 == "공간에 대한 나의 생각을 자유롭게 적어주세요!" {
          return "0 / 300"
        } else {
          return "\($0.count) / 300"
        }
      }
      .assign(to: \.contentsTextCount, on: self)
      .store(in: &cancellables)

    Publishers.CombineLatest4($selectedAsset, $place, $contents, $exhibitionName)
      .map { asset, place, contents, exhibitionName in
        return asset != nil &&
        exhibitionName.count > 0 &&
        contents.count > 0 &&
        contents != "공간에 대한 나의 생각을 자유롭게 적어주세요!" &&
        place != nil
      }
      .assign(to: \.uploadEnabled, on: self)
      .store(in: &cancellables)
  }

  func getPhotoPermission(completionHandler: @escaping (Bool) -> Void) {
    PhotoKitManager.getPhotoPermission(completionHandler: completionHandler)
  }

  func uploadButtonTapped() {
    guard let asset = selectedAsset,
          let thumbnailData = PhotoKitManager.getAssetThumbnailData(asset: asset)
    else { return }

    awsUploader.upload(
      asset: asset,
      thumbnailData: thumbnailData
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let response):
        self.createRecord(
          videoUrl: response.videoUrl,
          thumbnailUrl: response.thumbnailUrl
        )
      case .failure(let error):
        print("fail to upload: \(error)")
      }
    }
  }

  private func createRecord(
    videoUrl: String,
    thumbnailUrl: String
  ) {
    var encodedString = ""
    guard let id = place?.id else { return }
    let request = DTO.CreateRecordRequest(
      fileUrl: DTO.CreateRecordRequest.FileUrl(
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl
      ),
      content: contents,
      exhibitionName: exhibitionName,
      placeId: id
    )

    apiProvider.justRequest(.createRecord(request)) { result in
      switch result {
      case .success:
        NotificationCenter.default.post(
          name: .updateDidComplete,
          object: nil,
          userInfo: ["message": "업로드가 완료되었어요!", "state": "success"]
        )
      case .failure:
        NotificationCenter.default.post(
          name: .updateDidComplete,
          object: nil,
          userInfo: ["message": "업로드에 실패했어요!", "state": "failure"]
        )
      }
    }
  }
}
