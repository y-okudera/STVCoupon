//
//  CouponDetailInteractor.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

/// API・DBからデータを取得する
protocol CouponDetailUsecase {
    func updateCoupon(couponEntity: CouponEntity)
}

/// 処理結果をPresenterに通知する
protocol CouponDetailInteractorDelegate: class {
    func didFinishUpdateCoupon()
}

// MARK: - class

final class CouponDetailInteractor {
    weak var output: CouponDetailInteractorDelegate?
}

extension CouponDetailInteractor: CouponDetailUsecase {
    
    func updateCoupon(couponEntity: CouponEntity) {
        let dao = CouponDao()
        dao.delegate = self
        dao.update(coupon: couponEntity)
        self.output?.didFinishUpdateCoupon()
    }
}

extension CouponDetailInteractor: CouponDaoDelegate {
    func caughtError(couponDao: CouponDao, error: Error) {
        assertionFailure("クーポンデータの更新失敗")
    }
}
