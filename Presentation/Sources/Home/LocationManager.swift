//
//  LocationManager.swift
//  Presentation
//
//  Created by Chandrala on 1/14/25.
//  Copyright © 2025 com.recordy. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  
  private let locationManager = CLLocationManager()
  
  var onAuthorizationStatusChanged: ((CLAuthorizationStatus) -> Void)?
  var onLocationUpdated: ((CLLocation) -> Void)?
  
  var currentAuthorizationStatus: CLAuthorizationStatus {
      return CLLocationManager.authorizationStatus()
  }
  
  private(set) var currentLocation: CLLocation?
  private(set) var currentLatitude: Double?
  private(set) var currentLongitude: Double?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  public func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  /// 위치 업데이트 시작
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    onAuthorizationStatusChanged?(status)
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLatitude = location.coordinate.latitude
      currentLongitude = location.coordinate.longitude
      onLocationUpdated?(location)
    }
    locationManager.stopUpdatingLocation()
  }
  
  /// 위치 업데이트 실패 시 호출
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("위치 업데이트 실패: \(error.localizedDescription)")
  }
}
