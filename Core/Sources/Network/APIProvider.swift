//
//  APIProvider.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya
import RxMoya
import RxSwift

public final class APIProvider<T: TargetType>: MoyaProvider<T> {

  public init() {
    let plugin: [PluginType] = [RecordyPlugin()]
    super.init(plugins: plugin)
  }

  public func request<U: Codable>(
    _ object: U.Type,
    target: T
  ) -> Single<Result<U, RecordyNetworkError>> {
    return self.rx.request(target)
      .map { response in
        let statusCode = response.statusCode
        let data = response.data
        return self.handleResponseStatus(statusCode, data, object)
      }
      .catch { error in
        return .just(
          .failure(
            .requestFailed("✅ 요청 문제 발생 - \(error.localizedDescription)")
          )
        )
      }
  }

  func handleResponseStatus<U: Codable>(
    _ statusCode: Int,
    _ data: Data,
    _ object: U.Type
  ) -> Result<U, RecordyNetworkError> {
    switch statusCode {
    case 200..<300:
      return decodeData(data, object)
    case 400..<500:
      return .failure(.requestFailed("✅ 클라이언트 문제에요. \(statusCode)"))
    case 500..<600:
      return .failure(.serverError("✅ 서버 문제에요. \(statusCode)"))
    default:
      return .failure(.invalidStatusCode(statusCode))
    }
  }

  private func decodeData<U: Codable>(
    _ data: Data,
    _ object: U.Type
  ) -> Result<U, RecordyNetworkError> {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(U.self, from: data)
      return .success(decodedData)
    } catch {
      print("⛔️ \(self)에서 디코딩 오류가 발생했습니다 ⛔️")
      print("오류 내용: \(error.localizedDescription)")
      print("디코딩하려는 타입: \(U.self)")
      if let jsonString = String(data: data, encoding: .utf8) {
        print("JSON 응답 데이터: \(jsonString)")
      }
      return .failure(.decodingFailed(error.localizedDescription))
    }
  }
}

