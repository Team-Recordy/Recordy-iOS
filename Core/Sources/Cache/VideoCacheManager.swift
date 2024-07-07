//
//  VideoCacheManager.swift
//  Core
//
//  Created by 한지석 on 7/7/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public final class VideoCacheManager {
  public static let shared = VideoCacheManager()
  private let cache: URLCache

  private init() {
    let memoryCapacity = 50 * 1024 * 1024
    let diskCapacity = 1000 * 1024 * 1024
    self.cache = URLCache(
      memoryCapacity: memoryCapacity,
      diskCapacity: diskCapacity,
      diskPath: "videoCache"
    )
    URLCache.shared = cache
  }

  private func getCachedData(url: URL) -> Data? {
    let urlRequest = URLRequest(url: url)
    if let cachedResponse = cache.cachedResponse(for: urlRequest) {
      return cachedResponse.data
    }
    return nil
  }

  private func cachedData(
    data: Data,
    urlResponse: URLResponse,
    url: URL
  ) {
    let urlRequest = URLRequest(url: url)
    let cachedResponse = CachedURLResponse(
      response: urlResponse,
      data: data
    )
    cache.storeCachedResponse(
      cachedResponse,
      for: urlRequest
    )
  }

  public func downloadAndCacheURL(
    url: URL,
    completion: @escaping (URL?) -> ()
  ) {
    /// 캐싱된 데이터가 존재할 경우
    if let cachedData = getCachedData(url: url) {
      let fileManager = FileManager.default
      let cachesDirectory = fileManager.urls(
        for: .cachesDirectory,
        in: .userDomainMask
      ).first!
      let destinationURL = cachesDirectory.appendingPathComponent(url.lastPathComponent)

      do {
        try cachedData.write(to: destinationURL)
        completion(destinationURL)
        return
      } catch {
        completion(nil)
        return
      }
    }

    /// 캐싱된 데이터가 없을 경우 URLRequest를 통해 데이터를 미리 받은 후 캐싱
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data,
            let response = response,
            error == nil
      else {
        completion(nil)
        return
      }

      self.cachedData(
        data: data,
        urlResponse: response,
        url: url
      )
      let fileManager = FileManager.default
      let cachesDirectory = fileManager.urls(
        for: .cachesDirectory,
        in: .userDomainMask
      ).first!
      let destinationURL = cachesDirectory.appendingPathComponent(url.lastPathComponent)

      do {
        try data.write(to: destinationURL)
        completion(destinationURL)
      } catch {
        completion(nil)
      }
    }
    task.resume()
  }
}
