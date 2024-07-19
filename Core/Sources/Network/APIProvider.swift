//
//  APIProvider.swift
//  Core
//
//  Created by 한지석 on 7/10/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Moya


public final class APIProvider<T: TargetType>: MoyaProvider<T> {
  //  typealias APIResult = Result<U: Codable, MoyaError>
  private let interceptor = BaseInterceptor()
  let decoder = JSONDecoder()

  public init() {
    let plugin: [PluginType] = [RecordyPlugin()]
    let session = Session(interceptor: interceptor)
    super.init(session: session, plugins: plugin)
  }

  public func justRequest(_ target: Target, completion: @escaping (Result<Void, Error>) -> Void) {
    request(target) { result in
      switch result {
      case .success:
        self.printLog(title: "response", message: "success")
        completion(.success(()))
      case let .failure(error):
        do {
          let apiError = try self.getAPIError(error)
          completion(.failure(apiError))
        } catch {
          completion(.failure(error))
        }
      }
    }
  }

  public func requestResponsable<U: Codable>(
    _ target: T,
    _ object: U.Type,
    completion: @escaping (Result<U, RecordyNetworkError>) -> Void
  ) {
    request(target) { response in
      switch response {
      case .success(let response):
        completion(self.handleResponseStatus(response.statusCode, response.data, U.self))
      case .failure(let error):
        completion(.failure(.requestFailed("@Log - \(error.localizedDescription)")))
      }
    }
  }

  public static func validateToken(completion: @escaping (Bool) -> Void) {

    let apiProvider = APIProvider<APITarget.Preference>()

    apiProvider.requestResponsable(.getPreference, DTO.GetPreferenceResponse.self) { result in
      switch result {
      case .success:
        completion(true)
      case .failure:
        completion(false)
      }
    }
  }

  func handleResponseStatus<U: Codable>(
    _ statusCode: Int,
    _ data: Data,
    _ object: U.Type
  ) -> Result<U, RecordyNetworkError> {
    switch statusCode {
    case 200..<300:
      return getResponse(data, object: object)
    case 400..<500:
      return .failure(.requestFailed("✅ 클라이언트 문제에요. \(statusCode)"))
    case 500..<600:
      return .failure(.serverError("✅ 서버 문제에요. \(statusCode)"))
    default:
      return .failure(.invalidStatusCode(statusCode))
    }
  }

  private func getResponse<U: Codable>(
    _ data: Data,
    object: U.Type
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

  private func getAPIError(_ error: MoyaError) throws -> APIError {
    guard let data = error.response?.data else {
      return .unknown
    }
    printLog(title: "response error", data: data)
    return try decoder.decode(APIError.self, from: data)
  }

  // TODO: - Logger

  private func printLog(title: String, data: Data) {
    let message = String(data: data, encoding: .utf8) ?? ""
    printLog(title: title, message: message)
  }

  private func printLog(title: String, message: String) {
    print("@LOG \(title)\n\(message)")
  }
}

struct APIError: Error, Decodable {
  let detail: String
}

extension APIError {
  static let unknown = APIError(detail: "unknown error")
}
