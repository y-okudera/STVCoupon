//
//  CouponListRouter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/01.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol CouponListWireframe: class {
    func showCouponDetail(_ couponEntity: CouponEntity)
}

// MARK: - class

final class CouponListRouter {

    weak var viewController: UIViewController?

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /// 依存関係の解決をする
    static func assembleModules() -> UIViewController {
        let view: CouponListViewController = .instantiate()
        let interactor = CouponListInteractor()
        let router = CouponListRouter(viewController: view)
        
        let couponListProvider = CouponListProvider()
        let presenter = CouponListPresenter(view: view,
                                            interactor: interactor,
                                            router: router,
                                            couponListProvider: couponListProvider)

        // Interactorの通知先にPresenterを設定
        interactor.output = presenter
        // ViewにPresenterを設定
        view.presenter = presenter

        view.navigationItem.title = "COUPON_LIST".localized()
        return view
    }
}

extension CouponListRouter: CouponListWireframe {
    
    func showCouponDetail(_ couponEntity: CouponEntity) {
        let couponDetailView = CouponDetailRouter.assembleModules(couponEntity: couponEntity)
        viewController?.present(couponDetailView, animated: true, completion: nil)
    }
}
