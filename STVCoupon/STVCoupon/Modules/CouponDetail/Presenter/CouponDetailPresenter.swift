//
//  CouponDetailPresenter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

protocol CouponDetailPresentation: class {
    func useCoupon()
    var couponEntity: CouponEntity! { get }
}

// MARK: - class

final class CouponDetailPresenter {

    // View, Interactor, Routerへのアクセスはprotocolを介して行う
    private weak var view: CouponDetailView?
    private let interactor: CouponDetailUsecase
    private let router: CouponDetailWireframe
    var couponEntity: CouponEntity!

    init(view: CouponDetailView, interactor: CouponDetailUsecase, router: CouponDetailWireframe, couponEntity: CouponEntity) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.couponEntity = couponEntity
    }
}

extension CouponDetailPresenter: CouponDetailPresentation {
    
    func useCoupon() {
        self.couponEntity.setUsedDate()
        self.interactor.updateCoupon(couponEntity: self.couponEntity)
    }
}

extension CouponDetailPresenter: CouponDetailInteractorDelegate {
    
    func didFinishUpdateCoupon() {
        view?.reloadView(couponDetailViewStatus: .used)
    }
}
