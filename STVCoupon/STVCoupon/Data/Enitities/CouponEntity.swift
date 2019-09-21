//
//  CouponEntity.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

class CouponEntity: RealmSwift.Object {
    
    /// クーポンのID
    @objc dynamic var couponID = ""
    /// 割引金額
    @objc dynamic var priceDown = 0
    /// 有効期限の開始日
    @objc dynamic var fromExpire = ""
    /// 有効期限の終了日
    @objc dynamic var toExpire = ""
    
    /// 利用状況（未利用/利用済み）
    @objc dynamic var used = false
    /// いいねステータス（いいね済み/いいねしていない）
    @objc dynamic var wished = false
    
    override static func primaryKey() -> String? {
        return "couponID"
    }
    
    convenience init(coupon: Coupon) {
        self.init()
        self.couponID = coupon.couponID
        self.priceDown = coupon.priceDown
        self.fromExpire = coupon.fromExpire
        self.toExpire = coupon.toExpire
    }
}
