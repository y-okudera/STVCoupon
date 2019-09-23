//
//  CouponListInteractorMock.swift
//  STVCouponTests
//
//  Created by Yuki Okudera on 2019/09/23.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

@testable import STVCoupon
import Foundation

final class CouponListInteractorMock: CouponListUsecase {
    
    weak var output: CouponListInteractorDelegate?
    
    /// func requestCouponList()の呼び出し回数
    static var requestCouponList_CallCount = 0
    
    /// func updateCoupon(couponEntity: CouponEntity)の呼び出し回数
    static var updateCoupon_CallCount = 0
    
    func requestCouponList() {
        CouponListInteractorMock.requestCouponList_CallCount += 1
        output?.didFetchCouponList(coupons: self.couponEntities())
    }
    
    func updateCoupon(couponEntity: CouponEntity) {
        CouponListInteractorMock.updateCoupon_CallCount += 1
        output?.didFinishUpdate(coupons: self.couponEntities())
    }
}

extension CouponListInteractorMock {
    
    func resetCallCount() {
        CouponListInteractorMock.requestCouponList_CallCount = 0
        CouponListInteractorMock.updateCoupon_CallCount = 0
    }
    
    private var jsonData: Data? {
        let jsonString = """
{
    "returnCode": "0000",
    "couponCount": 6,
    "couponList": [
        {
            "couponID": "c123455",
            "priceDown": 2000,
            "fromExpire": "20190801",
            "toExpire": "20190831"
        },
        {
            "couponID": "c123456",
            "priceDown": 500,
            "fromExpire": "20190901",
            "toExpire": "20190930"
        },
        {
            "couponID": "c123457",
            "priceDown": 1000,
            "fromExpire": "20190915",
            "toExpire": "20190930"
        },
        {
            "couponID": "c123458",
            "priceDown": 2000,
            "fromExpire": "20190915",
            "toExpire": "20190930"
        },
        {
            "couponID": "c123459",
            "priceDown": 2000,
            "fromExpire": "20191001",
            "toExpire": "20191030"
        },
        {
            "couponID": "c123460",
            "priceDown": 3000,
            "fromExpire": "20191015",
            "toExpire": "20191030"
        }
    ]
}
"""
        return jsonString.data(using: .utf8)
    }
    
    private func couponListAPIResponseMock() -> CouponListAPIResponse {
        // JSONをデコード
        let response = try! JSONDecoder().decode(CouponListAPIResponse.self, from: jsonData!)
        return response
    }
    
    private func couponEntities() -> [CouponEntity] {
        let couponList = couponListAPIResponseMock().couponList
        let couponEntities = couponList.map { CouponEntity(coupon: $0) }
        print("couponEntities", couponEntities)
        return couponEntities
    }
}
