//
//  AWSS3Uploader.swift
//  Core
//
//  Created by 한지석 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation
import Photos

//import Common

import AWSS3

public class AWSS3Uploader {
  private let apiProvider = APIProvider<APITarget.Records>()

  public init() { }

  public func upload(
    asset: PHAsset,
    thumbnailData: Data,
    completion: @escaping (Result<(videoUrl: String, thumbnailUrl: String), Error>) -> Void
  ) {
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
          self.upload(
            binaryData!,
            toPresignedURL: URL(string: response.videoUrl)!
          ) { result in
            switch result {
            case .success(let url):
              videoUrl = self.removeQueryParameters(url: url)
            case .failure(let failure):
              uploadError = failure
            }
          }

          dispatchGroup.enter()
          self.upload(
            thumbnailData,
            toPresignedURL: URL(string: response.thumbnailUrl)!
          ) { result in
            switch result {
            case .success(let url):
              thumbnailUrl = self.removeQueryParameters(url: url)
            case .failure(let failure):
              uploadError = failure
            }
            dispatchGroup.leave()
          }

          dispatchGroup.notify(queue: .global()) {
            guard uploadError == nil, let videoUrl, let thumbnailUrl else {
              NotificationCenter.default.post(
                name: .updateDidComplete,
                object: nil,
                userInfo: ["message": "업로드에 실패했어요!", "state": "failure"]
              )
              completion(.failure(uploadError!))
              return
            }
            completion(.success((
              videoUrl: videoUrl,
              thumbnailUrl: thumbnailUrl
            )))
          }
          
        case .failure(let failure):
          NotificationCenter.default.post(
            name: .updateDidComplete,
            object: nil,
            userInfo: ["message": "업로드에 실패했어요!", "state": "failure"]
          )
          completion(.failure(failure))
        }
      }
    }
  }

  private func upload(
    _ data: Data,
    toPresignedURL remoteURL: URL,
    completion: @escaping (Result<String?, Error>) -> Void
  ) {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10

    let session = URLSession(configuration: configuration)

    var request = URLRequest(url: remoteURL)
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.httpMethod = "PUT"
    request.setValue(
      "application/octet-stream",
      forHTTPHeaderField: "Content-Type"
    )

    let uploadTask = session.uploadTask(
      with: request,
      from: data
    ) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard response != nil, data != nil else {
        completion(.success(nil))
        return
      }
      completion(.success(String(describing: remoteURL)))
    }
    uploadTask.resume()
  }

  private func removeQueryParameters(url: String?) -> String? {
    guard let urlString = url else { return nil }
    if let urlComponents = URLComponents(string: urlString) {
      var modifiedComponents = urlComponents
      modifiedComponents.query = nil
      return modifiedComponents.string
    }
    return nil
  }
}
