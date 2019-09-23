//
//  STVCouponUITests.swift
//  STVCouponUITests
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import XCTest

final class STVCouponUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// クーポン一覧画面でいいねボタンをタップした場合のテスト
    ///
    /// スクロールをして、セルの再利用が発生してもいいねボタンの状態が正しいことを確認する
    func testCouponWishAndUnwish() {
        
        let app = XCUIApplication()
        
        let collectionView = app.collectionViews.element
        let firstCell = collectionView.children(matching: .cell).element(boundBy: 0)
        
        // いいねボタン
        let wishButton = firstCell.buttons["wish"]
        
        // いいねボタンタップ
        wishButton.tap()
        
        // スクロール
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeDown()
        
        // いいねボタンタップ(いいね解除)
        wishButton.tap()
        
        // スクロール
        collectionView.swipeUp()
        collectionView.swipeUp()
        collectionView.swipeDown()
        
        sleep(1)
    }
}
