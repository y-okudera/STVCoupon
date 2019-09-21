//
//  CouponListPresenter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

protocol CouponListPresentation: class {
    func viewWillAppear()
}

// MARK: - class

final class CouponListPresenter {

    // View, Interactor, Routerへのアクセスはprotocolを介して行う
    private weak var view: CouponListView?
    private let interactor: CouponListUsecase
    private let router: CouponListWireframe

    init(view: CouponListView, interactor: CouponListUsecase, router: CouponListWireframe) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CouponListPresenter: CouponListPresentation {
    func viewWillAppear() {
        print("クーポン一覧取得リクエスト")
        interactor.requestCouponList()
    }
}

extension CouponListPresenter: CouponListInteractorDelegate {
    
    func didFetchCouponList(coupons: [CouponEntity]) {
        if coupons.isEmpty {
            // クーポン0件の場合のUI更新
            view?.showCouponIsZeroMessage()
            return
        }
        view?.reloadCouponList(coupons: coupons)
    }
    
    func didFailWithAPIError(errorMessage: String) {
        view?.showAlert(title: "ERROR".localized(), message: errorMessage)
    }
}
