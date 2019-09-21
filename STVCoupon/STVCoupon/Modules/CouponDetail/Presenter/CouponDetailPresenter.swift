//
//  CouponDetailPresenter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

protocol CouponDetailPresentation: class {
    func viewDidLoad()
}

// MARK: - class

final class CouponDetailPresenter {

    // View, Interactor, Routerへのアクセスはprotocolを介して行う
    private weak var view: CouponDetailView?
    private let interactor: CouponDetailUsecase
    private let router: CouponDetailWireframe
    private var couponEntity: CouponEntity!

    init(view: CouponDetailView, interactor: CouponDetailUsecase, router: CouponDetailWireframe, couponEntity: CouponEntity) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.couponEntity = couponEntity
        
        print("couponEntity", couponEntity)
    }
}

extension CouponDetailPresenter: CouponDetailPresentation {
    func viewDidLoad() {
        print(String(describing: type(of: self)), #line, #function)
        interactor.requestLogin(userId: "userA", password: "password", uuid: UUID().uuidString)
    }
}

extension CouponDetailPresenter: CouponDetailInteractorDelegate {

    func didSucceedLogin() {
        view?.showAlert(title: nil, message: "ログイン成功")
    }

    func didFailLoginWithAPIError(apiError: Error) {
        print(apiError)
    }
}
