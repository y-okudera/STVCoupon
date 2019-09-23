//
//  CouponDetailRouter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/01.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol CouponDetailWireframe: class {
    // 画面遷移処理を実装する
}

// MARK: - class

final class CouponDetailRouter {

    weak var viewController: UIViewController?

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /// 依存関係の解決をする
    static func assembleModules(couponEntity: CouponEntity) -> UIViewController {
        let view: CouponDetailViewController = .instantiate()
        let interactor = CouponDetailInteractor()
        let router = CouponDetailRouter(viewController: view)
        let presenter = CouponDetailPresenter(view: view, interactor: interactor, router: router, couponEntity: couponEntity)

        // Interactorの通知先にPresenterを設定
        interactor.output = presenter
        // ViewにPresenterを設定
        view.presenter = presenter

        view.navigationItem.title = "クーポン詳細"
        return view
    }
}

extension CouponDetailRouter: CouponDetailWireframe {
    
}
