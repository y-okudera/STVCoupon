//
//  CouponListPresenter.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

// MARK: - protocol

protocol CouponListPresentation: class {
    
    var couponListProvider: CouponListProvider! { get set }
    func viewWillAppear()
    func didSelectItemAt(indexPath: IndexPath)
}

// MARK: - class

final class CouponListPresenter {
    
    var couponListProvider: CouponListProvider!

    // View, Interactor, Routerへのアクセスはprotocolを介して行う
    private weak var view: CouponListView?
    private let interactor: CouponListUsecase
    private let router: CouponListWireframe

    init(view: CouponListView, interactor: CouponListUsecase, router: CouponListWireframe, couponListProvider: CouponListProvider) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.couponListProvider = couponListProvider
        self.couponListProvider.couponListCellDelegate = self
    }
}

extension CouponListPresenter: CouponListPresentation {
    func viewWillAppear() {
        print("クーポン一覧取得リクエスト")
        interactor.requestCouponList()
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        print("didSelectItemAt", indexPath)
        
        if couponListProvider.couponEntities[indexPath.row].usedDate != nil {
            print("indexPath: \(indexPath)は、使用済み")
            return
        }
        
        // TODO: 画面遷移を実装する
    }
}

extension CouponListPresenter: CouponListInteractorDelegate {
    
    func didFetchCouponList(coupons: [CouponEntity]) {
        if coupons.isEmpty {
            // クーポン0件の場合のUI更新
            view?.showCouponIsZeroMessage()
            return
        }
        self.couponListProvider.set(couponEntities: coupons)
        view?.reloadCouponList()
    }
    
    func didFailWithAPIError(errorMessage: String) {
        view?.showAlert(title: "ERROR".localized(), message: errorMessage)
    }
    
    func didFinishUpdate(coupons: [CouponEntity]) {
        self.couponListProvider.set(couponEntities: coupons)
        view?.reloadCouponList()
    }
}

extension CouponListPresenter: CouponListCellDelegate {
    
    func tappedWishButton(newValue: CouponEntity) {
        interactor.updateCoupon(couponEntity: newValue)
    }
}
