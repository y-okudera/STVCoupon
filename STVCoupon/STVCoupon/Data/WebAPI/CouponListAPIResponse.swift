//
//  CouponListAPIResponse.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct CouponListAPIResponse: Decodable {
    
    /// APIの処理結果
    var returnCode = ""
    /// 総クーポン数
    var couponCount = 0
    /// クーポンデータ
    var couponList: [Coupon] = []
}

struct Coupon: Decodable {
    
    /// クーポンのID
    var couponID = ""
    /// 割引金額
    var priceDown = 0
    /// 有効期限の開始日
    var fromExpire = ""
    /// 有効期限の終了日
    var toExpire = ""
}

struct CouponListAPIErrorResponse: Decodable {}
