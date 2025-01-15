//
//  LocationManager.swift
//  Presentation
//
//  Created by Chandrala on 1/14/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  var onLocationUpdate: ((CLLocation) -> Void)?
  var onAuthorizationDenied: (() -> Void)?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  /// 위치 권한 요청
  func requestAuthorization() {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      startUpdatingLocation()
    case .denied, .restricted:
      onAuthorizationDenied?()
    default:
      break
    }
  }
  
  /// 위치 업데이트 시작
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  /// 권한 상태 변경 시 호출
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      startUpdatingLocation()
    case .denied, .restricted:
      onAuthorizationDenied?()
    default:
      break
    }
  }
  
  /// 위치 업데이트 성공 시 호출
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    onLocationUpdate?(location)
    locationManager.stopUpdatingLocation()
  }
  
  /// 위치 업데이트 실패 시 호출
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("위치 업데이트 실패: \(error.localizedDescription)")
  }
}
