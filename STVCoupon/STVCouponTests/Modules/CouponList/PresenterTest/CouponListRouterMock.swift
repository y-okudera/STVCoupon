//
//  CouponListRouterMock.swift
//  STVCouponTests
//
//  Created by Yuki Okudera on 2019/09/23.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

@testable import STVCoupon
import UIKit

final class CouponListRouterMock: CouponListWireframe {
    
    /// func showCouponDetail(_ couponEntity: CouponEntity)の呼び出し回数
    static var showCouponDetail_CallCount = 0
    
    func showCouponDetail(_ couponEntity: CouponEntity) {
        CouponListRouterMock.showCouponDetail_CallCount += 1
    }
}

extension CouponListRouterMock {
    func resetCallCount() {
        CouponListRouterMock.showCouponDetail_CallCount = 0
    }
}
