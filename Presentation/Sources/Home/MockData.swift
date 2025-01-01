//
//  MockData.swift
//  Presentation
//
//  Created by Chandrala on 10/29/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//

import Foundation

import Core
import Common

public let mockData: [Overview] = [
  Overview(places: [
    Place(
      shortenLocation: "서울 종로구",
      detailLocation: "서울시 종로구 삼청로 30",
      title: "국립현대미술관 서울관",
      reviewFeeds: ["Great exhibition!", "Loved the architecture!", "Amazing modern art."],
      placeInfoList: [
        PlaceInfo(feature: .all, title: "전시 1", duration: "2024년 10월 31일~2024년 10월 31일"),
        PlaceInfo(feature: .all, title: "전시 2", duration: "2024년 10월 31일~2024년 10월 31일")
      ],
      placeReview: PlaceReview(rating: 4.5, comments: "추천할 만한 멋진 공간이에요.")
    ),
    Place(
      shortenLocation: "서울 용산구",
      detailLocation: "서울시 용산구 한강대로 123",
      title: "용산 전쟁기념관",
      reviewFeeds: ["Historical and moving experience.", "Very educational!", "A must-visit for history buffs."],
      placeInfoList: [
        PlaceInfo(feature: .all, title: "전시 1", duration: "2024년 10월 31일~2024년 10월 31일"),
        PlaceInfo(feature: .all, title: "전시 2", duration: "2024년 10월 31일~2024년 10월 31일")
      ],
      placeReview: PlaceReview(rating: 4.8, comments: "역사에 관심이 많다면 꼭 방문해 보세요.")
    ),
    Place(
      shortenLocation: "서울 강남구",
      detailLocation: "서울시 강남구 테헤란로 20",
      title: "코엑스 몰",
      reviewFeeds: ["Great place for shopping and dining!", "Good cinema and aquarium.", "Lots of brand stores."],
      placeInfoList: [
        PlaceInfo(feature: .all, title: "전시 1", duration: "2024년 10월 31일~2024년 10월 31일"),
        PlaceInfo(feature: .all, title: "전시 2", duration: "2024년 10월 31일~2024년 10월 31일")
      ],
      placeReview: PlaceReview(rating: 4.3, comments: "다양한 상점과 즐길 거리가 많아요.")
    )
  ])
]
