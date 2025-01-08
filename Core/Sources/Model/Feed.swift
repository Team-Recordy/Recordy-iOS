//
//  Feed.swift
//  Core
//
//  Created by 한지석 on 7/9/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

public struct Feed: Equatable {
  public let id: Int
  public let userId: Int
  public let location: String
//  public let placeInfo: PlaceInfo
  public let nickname: String
  public let description: String
  public var isBookmarked: Bool
  public var bookmarkCount: Int
  public let videoLink: String
  public let thumbnailLink: String
  public let isMine: Bool

  public init(
    id: Int,
    userId: Int,
    location: String,
//    placeInfo: PlaceInfo,
    nickname: String,
    description: String,
    isBookmarked: Bool,
    bookmarkCount: Int,
    videoLink: String,
    thumbnailLink: String,
    isMine: Bool
  ) {
    self.id = id
    self.userId = userId
    self.location = location
//    self.placeInfo = placeInfo
    self.nickname = nickname
    self.description = description
    self.isBookmarked = isBookmarked
    self.bookmarkCount = bookmarkCount
    self.videoLink = videoLink
    self.thumbnailLink = thumbnailLink
    self.isMine = isMine
  }
}

extension Feed {
  public static let mockData: [Feed] = [
    Feed(
      id: 0,
      userId: 0,
      location: "서울특별시 강남구",
//      placeInfo: PlaceInfo(feature: .all, title: "AK PLAXA 홍대", duration: "2024.11 ~"),
      nickname: "호날두",
      description: "동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세",
      isBookmarked: false,
      bookmarkCount: 100,
      videoLink: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      thumbnailLink: "https://static-cse.canva.com/blob/1100862/youtube.jpg",
      isMine: false
    ),
    Feed(
      id: 0,
      userId: 0,
      location: "서울 종로",
//      placeInfo: PlaceInfo(feature: .all, title: "국립현대미술관", duration: "2024.11 ~"),
      nickname: "호날두",
      description: "동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세",
      isBookmarked: false,
      bookmarkCount: 100,
      videoLink: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      thumbnailLink: "https://static-cse.canva.com/blob/1100862/youtube.jpg",
      isMine: false
    ),
    Feed(
      id: 0,
      userId: 0,
      location: "서울특별시 강남구",
//      placeInfo: PlaceInfo(feature: .all, title: "AK PLAXA 홍대", duration: "2024.11 ~"),
      nickname: "호날두",
      description: "동해물과 백두산이 마르고 닳도록, 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려강산 대한사람 대한으로 길이 보전하세",
      isBookmarked: false,
      bookmarkCount: 100,
      videoLink: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
      thumbnailLink: "https://static-cse.canva.com/blob/1100862/youtube.jpg",
      isMine: false
    )
  ]
}
