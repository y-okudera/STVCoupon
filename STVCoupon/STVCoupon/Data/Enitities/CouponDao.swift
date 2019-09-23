//
//  CouponDao.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

protocol CouponDaoDelegate: class {
    func caughtError(couponDao: CouponDao, error: Error)
}

final class CouponDao {
    
    weak var delegate: CouponDaoDelegate?
    
    // MARK: - DELETE
    
    /// クーポン情報を全件削除する
    func deleteAll() {
        let dao = RealmDaoHelper<CouponEntity>()
        do {
            try dao.deleteAll()
        } catch {
            delegate?.caughtError(couponDao: self, error: error)
        }
    }
    
    // MARK: - ADD
    
    /// クーポン情報を登録する
    func add(coupons: [Coupon]) {
        let dao = RealmDaoHelper<CouponEntity>()
        var objects = [CouponEntity]()
        coupons.forEach {
            let object = CouponEntity(coupon: $0)
            objects.append(object)
        }
        
        do {
            try dao.add(objects: objects)
        } catch {
            print("add(coupons: [Coupon]) ERROR", error)
            delegate?.caughtError(couponDao: self, error: error)
        }
    }
    
    // MARK: - Find
    
    /// クーポンを全件取得する
    func findAll() -> [CouponEntity] {
        let dao = RealmDaoHelper<CouponEntity>()
        let list = dao.findAll()
        return Array(list)
    }
    
    /// クーポンを全件取得する
    ///
    /// 有効期限の新しい順、価格の安い順
    func findAllSortedByFromExpireAndPriceDown() -> [CouponEntity] {
        let dao = RealmDaoHelper<CouponEntity>()
        var list = dao.findAll()
        list = list.sorted(byKeyPath: "fromExpire")
        list = list.sorted(byKeyPath: "priceDown")
        return Array(list)
    }
    
    // MARK: - UPDATE
    
    /// クーポン情報を更新する
    ///
    /// - Parameter coupon: 更新したクーポン情報
    func update(coupon: CouponEntity) {
        let dao = RealmDaoHelper<CouponEntity>()
        do {
            try dao.update(d: coupon)
        } catch {
            print("update(user: CouponEntity) ERROR", error)
            delegate?.caughtError(couponDao: self, error: error)
        }
    }
}
