//
//  CouponListPresenterTests.swift
//  STVCouponTests
//
//  Created by Yuki Okudera on 2019/09/23.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

@testable import STVCoupon
import XCTest

final class CouponListPresenterTests: XCTestCase {
    // 依存するクラスの初期化
    let view = CouponListViewMock()
    let interactor = CouponListInteractorMock()
    let router = CouponListRouterMock()
    var presenter: CouponListPresenter!
    let couponListProvider = CouponListProvider()

    override func setUp() {
        presenter = CouponListPresenter(view: view,
                                        interactor: interactor,
                                        router: router,
                                        couponListProvider: couponListProvider)
        interactor.output = presenter
        view.presenter = presenter
    }
    
    override func tearDown() {
        view.resetCallCount()
        interactor.resetCallCount()
        router.resetCallCount()
    }
    
    /// PresenterにviewWillAppearのイベントが届いたときの挙動をテスト
    ///
    /// Interactorにクーポン一覧取得リクエストをするよう依頼しているかチェック
    func test_viewWillAppear() {
        XCTContext.runActivity(named: "viewWillAppearのテスト") { _ in
            
            XCTContext.runActivity(named: "viewWillAppear実行前の状態をテスト") { _ in
                XCTContext.runActivity(named: "`requestCouponList` はコールされていないことをテスト") { _ in
                    XCTAssertEqual(CouponListInteractorMock.requestCouponList_CallCount, 0)
                }
            }
            
            XCTContext.runActivity(named: "viewWillAppear実行後の状態をテスト") { _ in
                
                // execute
                presenter.viewWillAppear()
                
                // verify
                XCTContext.runActivity(named: "`requestCouponList` が1度だけコールされていることをテスト") { _ in
                    XCTAssertEqual(CouponListInteractorMock.requestCouponList_CallCount, 1)
                }
                XCTContext.runActivity(named: "couponEntitiesの件数をテスト") { _ in
                    XCTAssertEqual(presenter.couponListProvider.couponEntities.count, 6)
                }
                XCTContext.runActivity(named: "`reloadCouponList` が1度だけコールされていることをテスト") { _ in
                    XCTAssertEqual(CouponListViewMock.reloadCouponList_CallCount, 1)
                }
            }
        }
    }
    
    /// PresenterにdidSelectItemAtのイベントが届いたときの挙動をテスト(未使用のクーポンが選択されたケース)
    ///
    /// Routerにクーポン詳細画面へ遷移するよう依頼しているかチェック
    func test_didSelectItemAt_whenSelectedCouponIsUnused() {
        XCTContext.runActivity(named: "didSelectItemAtのテスト(未使用のクーポンが選択されたケース)") { _ in
            
            XCTContext.runActivity(named: "didSelectItemAt実行前の状態をテスト") { _ in
                XCTContext.runActivity(named: "`showCouponDetail` はコールされていないことをテスト") { _ in
                    XCTAssertEqual(CouponListRouterMock.showCouponDetail_CallCount, 0)
                }
            }
            
            XCTContext.runActivity(named: "didSelectItemAt実行後の状態をテスト") { _ in
                
                // setup
                presenter.viewWillAppear()
                // 未使用のクーポンのIndexPathを指定
                let indexPath = IndexPath(row: 0, section: 0)
                
                // execute
                presenter.didSelectItemAt(indexPath: indexPath)
                
                // verify
                XCTContext.runActivity(named: "`showCouponDetail` が1度だけコールされていることをテスト") { _ in
                    XCTAssertEqual(CouponListRouterMock.showCouponDetail_CallCount, 1)
                }
            }
        }
    }
    
    /// PresenterにdidSelectItemAtのイベントが届いたときの挙動をテスト(使用済みのクーポンが選択されたケース)
    ///
    /// Routerに処理を依頼していないことをチェック
    func test_didSelectItemAt_whenSelectedCouponIsUsed() {
        
        XCTContext.runActivity(named: "didSelectItemAtのテスト(使用済みのクーポンが選択されたケース)") { _ in
            
            XCTContext.runActivity(named: "didSelectItemAt実行前の状態をテスト") { _ in
                XCTContext.runActivity(named: "`showCouponDetail` はコールされていないことをテスト") { _ in
                    XCTAssertEqual(CouponListRouterMock.showCouponDetail_CallCount, 0)
                }
            }
            
            XCTContext.runActivity(named: "didSelectItemAt実行後の状態をテスト") { _ in
                
                // setup
                self.setUsedCoupon()
                // 使用済みのクーポンのIndexPathを指定
                let indexPath = IndexPath(row: 0, section: 0)
                
                // execute
                presenter.didSelectItemAt(indexPath: indexPath)
                
                // verify
                XCTContext.runActivity(named: "`showCouponDetail` が1度だけコールされていることをテスト") { _ in
                    XCTAssertEqual(CouponListRouterMock.showCouponDetail_CallCount, 0)
                }
            }
        }
    }
}

extension CouponListPresenterTests {
    
    /// 使用済みのクーポンを1件クーポンリストプロバイダーにセットする
    private func setUsedCoupon() {
        let usedCouponEntity = CouponEntity(coupon: Coupon())
        usedCouponEntity.usedDate = "2019/09/21 12:34:56"
        presenter.couponListProvider.set(couponEntities: [usedCouponEntity])
    }
}
