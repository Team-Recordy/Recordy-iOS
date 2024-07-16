//
//  ComponentType.swift
//  Presentation
//
//  Created by 송여경 on 7/16/24.
//  Copyright © 2024 com.recordy. All rights reserved.
//
protocol ComponentType {
    
    associatedtype Input
    associatedtype Output
    
    func interface(input: Input) -> Output
}
