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
  public let videoLink: String
  public let thumbnailLink: String
  public let description: String
  public let exhibitionName: String
  public let placeId: Int
  public let placeName: String
  public let uploaderId: Int
  public let uploaderNickname: String
  public var bookmarkCount: Int
  public let isMine: Bool
  public var isBookmarked: Bool
  
  public init(
    id: Int,
    videoLink: String,
    thumbnailLink: String,
    description: String,
    exhibitionName: String,
    placeId: Int,
    placeName: String,
    uploaderId: Int,
    uploaderNickname: String,
    bookmarkCount: Int,
    isMine: Bool,
    isBookmarked: Bool
  ) {
    self.id = id
    self.videoLink = videoLink
    self.thumbnailLink = thumbnailLink
    self.description = description
    self.exhibitionName = exhibitionName
    self.placeId = placeId
    self.placeName = placeName
    self.uploaderId = uploaderId
    self.uploaderNickname = uploaderNickname
    self.bookmarkCount = bookmarkCount
    self.isMine = isMine
    self.isBookmarked = isBookmarked
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
