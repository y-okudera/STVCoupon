//
//  CouponDetailViewController.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/01.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - protocol

protocol CouponDetailView: class {
    func showAlert(title: String?, message: String)
}

// MARK: - class

/// クーポン詳細画面
final class CouponDetailViewController: UIViewController {
    
    @IBOutlet weak var couponBaseViewHeightLayout: NSLayoutConstraint! {
        didSet {
            couponBaseViewHeightLayout.constant = 250
        }
    }
    
    @IBOutlet weak var couponTitleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    // willUseView
    @IBOutlet var willUseView: UIView!
    @IBOutlet weak var expireLabel: UILabel!
    
    // willUseView
    @IBOutlet var usageConfirmView: UIView!
    
    // willUseView
    @IBOutlet var usedView: UIView!
    @IBOutlet weak var usedDateLabel: UILabel!
    // Presenterへのアクセスはprotocolを介して行う
    var presenter: CouponDetailPresentation!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        #if DEBUG
        couponBaseViewHeightLayout.constant = 250 + 280
        stackView.addArrangedSubview(usageConfirmView)
        #endif
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            let couponListViewController = self.presentingViewController as! CouponListViewController
            couponListViewController.reloadCouponList()
        }
    }
    
    /// 使う
    @IBAction func tappedUseButton(_ sender: UIButton) {
    }
    
    /// 使う(詳細)
    @IBAction func tappedUseInConfirm(_ sender: UIButton) {
    }
    
    /// 今は使わない
    @IBAction func tappedUnuseInConfirm(_ sender: UIButton) {
    }
}

extension CouponDetailViewController: CouponDetailView {
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(
            .init(title: "OK", style: .default)
        )
        self.present(alert, animated: true, completion: nil)
    }
}
