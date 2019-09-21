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
    
    /// 利用日時（yyyy/MM/dd hh:mm:ss）
    ///
    /// 未使用の場合は、nil
    @objc dynamic var usedDate: String?
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
    
    convenience init(value: CouponEntity) {
        self.init()
        self.couponID = value.couponID
        self.priceDown = value.priceDown
        self.fromExpire = value.fromExpire
        self.toExpire = value.toExpire
        self.usedDate = value.usedDate
        self.wished = value.wished
    }
    
    /// 有効期間を文字列で取得する
    func validPeriod() -> String {
        
        return "\(fromExpire)〜\(toExpire)"
    }
}
