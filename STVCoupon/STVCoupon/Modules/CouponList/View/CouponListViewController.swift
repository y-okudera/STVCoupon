//
//  CouponListViewController.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/01.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol CouponListView: class {
    func reloadCouponList()
    func showCouponIsZeroMessage()
    func showAlert(title: String?, message: String)
}

// MARK: - class

/// クーポン一覧画面
final class CouponListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // Presenterへのアクセスはprotocolを介して行う
    var presenter: CouponListPresentation!
    var couponListProvider: CouponListProvider!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = presenter.couponListProvider
        collectionView.delegate = self
        CouponListCell.register(collectionView: collectionView)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension CouponListViewController: CouponListView {
    
    /// クーポン一覧を更新する
    func reloadCouponList() {
        collectionView.reloadData()
    }
    
    /// クーポン0件のメッセージを表示する
    func showCouponIsZeroMessage() {
        print("couponIsZero")
    }
    
    /// アラートを表示する
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            .init(title: "OK".localized(), style: .default)
        )
        present(alert, animated: true, completion: nil)
    }
}

extension CouponListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexPath: indexPath)
    }
}
