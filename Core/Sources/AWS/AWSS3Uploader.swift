//
//  AWSS3Uploader.swift
//  Core
//
//  Created by 한지석 on 7/18/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import AWSS3

public class AWSS3Uploader {
  public static func upload(
    _ data: Data,
    toPresignedURL remoteURL: URL,
    completion: @escaping (Result<String?, Error>) -> Void
  ) {
    var request = URLRequest(url: remoteURL)
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.httpMethod = "PUT"
    request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

    let uploadTask = URLSession.shared.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard response != nil, data != nil else {
            completion(.success(nil))
            return
        }
        completion(.success(String(describing: remoteURL)))
    })
    uploadTask.resume()
  }
}
