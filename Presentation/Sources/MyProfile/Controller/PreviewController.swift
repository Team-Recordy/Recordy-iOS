////
////  PreviewController.swift
////  Presentation
////
////  Created by 송여경 on 10/14/24.
////  Copyright © 2024 com.recordy. All rights reserved.
////
//import UIKit
//import SnapKit
//
///// 컴포넌트를 실제 VC에서 snp 적용했을 때 표시되는 내용을 확인하는 ViewController입니다.
///// - Parameter viewController: 표시할 ViewController
///// - Parameter setupSnp: 해당 컴포넌트에 적용하는 snp 로직
//final class PreviewController: UIViewController {
//    
//    private let childViewController: UIViewController
//    private var setupSnp: ((UIView) -> Void)?
//    
//    init(_ viewController: UIViewController, snp: @escaping (UIView) -> Void) {
//        self.childViewController = viewController
//        self.setupSnp = snp
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        
//        // Add the child view controller
//        addChild(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.didMove(toParent: self)
//        
//        // Apply constraints to the child view controller's view
//        setupSnp?(childViewController.view)
//    }
//}
//
//@available(iOS 17.0, *)
//#Preview {
//  MyPlaceEmptyView()
//}
