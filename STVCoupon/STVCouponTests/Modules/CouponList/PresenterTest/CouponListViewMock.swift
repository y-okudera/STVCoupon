//
//  CouponListViewMock.swift
//  STVCouponTests
//
//  Created by Yuki Okudera on 2019/09/23.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

@testable import STVCoupon
import UIKit

final class CouponListViewMock: CouponListView {
    
    var presenter: CouponListPresentation!
    
    /// func reloadCouponList()の呼び出し回数
    static var reloadCouponList_CallCount = 0
    
    /// func showAlert(title: String?, message: String)の呼び出し回数
    static var showAlert_CallCount = 0
    
    func reloadCouponList() {
        CouponListViewMock.reloadCouponList_CallCount += 1
    }
    
    func showAlert(title: String?, message: String) {
        CouponListViewMock.showAlert_CallCount += 1
    }
}

extension CouponListViewMock {
    
    func resetCallCount() {
        CouponListViewMock.reloadCouponList_CallCount = 0
    }
}
