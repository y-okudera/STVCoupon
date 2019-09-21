//
//  CouponListInteractor.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

/// API・DBからデータを取得する
protocol CouponListUsecase {
    func requestCouponList()
    func updateCoupon(couponEntity: CouponEntity)
}

/// 処理結果をPresenterに通知する
protocol CouponListInteractorDelegate: class {
    func didFetchCouponList(coupons: [CouponEntity])
    func didFailWithAPIError(errorMessage: String)
    func didFinishUpdate(coupons: [CouponEntity])
}

// MARK: - class

final class CouponListInteractor {
    weak var output: CouponListInteractorDelegate?
}

extension CouponListInteractor: CouponListUsecase {

    func requestCouponList() {
        let request = CouponListAPIRequest()
        APIClient.request(request: request)
            .done { response in
                guard let couponListResponse = response as? CouponListAPIResponse else {
                    assertionFailure("CouponListAPIResponse decoding failure")
                    return
                }
                
                print("returnCode", couponListResponse.returnCode)
                print("couponCount", couponListResponse.couponCount)
                print("couponList", couponListResponse.couponList)
                
                // APIのエラーチェック
                if let errorMessage = self.couponListAPIErrorMessage(response: couponListResponse) {
                    // エラーを通知
                    self.output?.didFailWithAPIError(errorMessage: errorMessage)
                    return
                }
                
                // データベースを更新
                self.updateDatabase(coupons: couponListResponse.couponList)
                
                // 正常終了を通知
                let savedCoupons = self.readCouponsFromDatabase()
                let coupons = savedCoupons.map { CouponEntity(value: $0) }
                self.output?.didFetchCouponList(coupons: coupons)
            }
            .catch { error in
                
                #if DEBUG
                guard let apiError = error as? APIError else {
                    assertionFailure("error is not APIError")
                    return
                }
                print(apiError.message)
                #endif
                
                // オフラインの場合は、データベースからクーポン情報を取得する
                if case .connectionError = apiError {
                    let savedCoupons = self.readCouponsFromDatabase()
                    // 正常終了を通知
                    let coupons = savedCoupons.map { CouponEntity(value: $0) }
                    self.output?.didFetchCouponList(coupons: coupons)
                }
                
                // エラーを通知
                let errorMessage = "COUPON_LIST_ERROR_9999".localized()
                self.output?.didFailWithAPIError(errorMessage: errorMessage)
        }
    }
    
    func updateCoupon(couponEntity: CouponEntity) {
        let dao = CouponDao()
        dao.delegate = self
        dao.update(coupon: couponEntity)
        
        let savedCoupons = self.readCouponsFromDatabase()
        let coupons = savedCoupons.map { CouponEntity(value: $0) }
        self.output?.didFinishUpdate(coupons: coupons)
    }
    
    /// APIのエラーチェック
    ///
    /// エラーメッセージが空の場合は正常終了
    private func couponListAPIErrorMessage(response: CouponListAPIResponse) -> String? {
        let returnCode: CouponListAPIReturnCode = CouponListAPIReturnCode(rawValue: response.returnCode) ?? .others
        
        let userMessage = returnCode.userMessage()
        if userMessage.isEmpty {
            return nil
        }
        return userMessage
    }
    
    /// データベースのクーポン情報を更新する
    private func updateDatabase(coupons: [Coupon]) {
        let dao = CouponDao()
        dao.delegate = self
        
        let savedCoupons = dao.findAll()
        var willAddCoupons = [Coupon]()
        
        var willAddCouponIDs = coupons.map { $0.couponID }
        let savedAddCouponIDs = savedCoupons.map { $0.couponID }
        willAddCouponIDs = willAddCouponIDs.filter { !savedAddCouponIDs.contains($0) }
        
        coupons.forEach {
            if willAddCouponIDs.contains($0.couponID) {
                willAddCoupons.append($0)
            }
        }
        
        print("willAddCoupons", willAddCoupons)
        if willAddCoupons.isEmpty {
            return
        }
        dao.add(coupons: willAddCoupons)
    }
    
    /// データベースのクーポン情報を更新する
    private func readCouponsFromDatabase() -> [CouponEntity] {
        let dao = CouponDao()
        dao.delegate = self
        
        let savedCouponEntities = dao.findAllSortedByFromExpireAndPriceDown()
        return savedCouponEntities
    }
}

extension CouponListInteractor: CouponDaoDelegate {
    func caughtError(couponDao: CouponDao, error: Error) {
        assertionFailure("クーポンデータの登録失敗")
    }
}
