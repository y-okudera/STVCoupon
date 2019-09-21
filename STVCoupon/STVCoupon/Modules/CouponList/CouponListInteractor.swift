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
}

/// 処理結果をPresenterに通知する
protocol CouponListInteractorDelegate: class {
    func didFetchCouponList(response: CouponListAPIResponse)
    func didFailWithAPIError(errorMessage: String)
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
                
                // 正常終了を通知
                self.output?.didFetchCouponList(response: couponListResponse)
            }
            .catch { error in
                
                #if DEBUG
                guard let apiError = error as? APIError else {
                    assertionFailure("error is not APIError")
                    return
                }
                print(apiError.message)
                #endif
                
                // エラーを通知
                let errorMessage = "COUPON_LIST_ERROR_9999".localized()
                self.output?.didFailWithAPIError(errorMessage: errorMessage)
        }
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
}
