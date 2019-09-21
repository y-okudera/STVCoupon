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
    func requestLogin(userId: String, password: String, uuid: String)
}

/// 処理結果をPresenterに通知する
protocol CouponDetailInteractorDelegate: class {
    func didSucceedLogin()
    func didFailLoginWithAPIError(apiError: Error)
}

// MARK: - class

final class CouponDetailInteractor {
    weak var output: CouponDetailInteractorDelegate?
}

extension CouponDetailInteractor: CouponDetailUsecase {

    func requestLogin(userId: String, password: String, uuid: String) {
        // ログインAPIのリクエストをする

        // 結果を通知する
        output?.didSucceedLogin()
    }
}
