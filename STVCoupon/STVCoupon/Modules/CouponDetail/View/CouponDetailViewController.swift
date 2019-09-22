//
//  CouponDetailViewController.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/01.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

enum CouponDetailViewStatus {
    
    case unused
    case usageConfirm
    case used
    
    func couponBaseViewHeight() -> CGFloat {
        switch self {
        case .unused:
            return CGFloat(250)
        case .usageConfirm:
            return CGFloat(500)
        case .used:
            return CGFloat(250)
        }
    }
}

// MARK: - protocol

protocol CouponDetailView: class {
    func reloadView(couponDetailViewStatus: CouponDetailViewStatus)
}

// MARK: - class

/// クーポン詳細画面
final class CouponDetailViewController: UIViewController {
    
    @IBOutlet private weak var couponBaseViewHeightLayout: NSLayoutConstraint! {
        didSet {
            couponBaseViewHeightLayout.constant = 250
        }
    }
    
    @IBOutlet private weak var couponTitleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    // willUseView
    @IBOutlet private var willUseView: UIView!
    @IBOutlet private weak var expireLabel: UILabel!
    
    // usageConfirmView
    @IBOutlet private var usageConfirmView: UIView!
    @IBOutlet private weak var expireLabelInUsageConfirmView: UILabel!
    
    // usedView
    @IBOutlet private var usedView: UIView!
    @IBOutlet private weak var usedDateLabel: UILabel!
    // Presenterへのアクセスはprotocolを介して行う
    var presenter: CouponDetailPresentation!
    
    private var stackedView: UIView?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.close))
        downSwipeGesture.direction = .down
        view.addGestureRecognizer(downSwipeGesture)
        
        stackView.addArrangedSubview(willUseView)
        stackView.addArrangedSubview(usageConfirmView)
        stackView.addArrangedSubview(usedView)
        reloadView(couponDetailViewStatus: .unused)
    }
    
    @IBAction private func tappedCloseButton(_ sender: UIButton) {
        close()
    }
    
    /// 使う
    @IBAction private func tappedUseButton(_ sender: UIButton) {
        reloadView(couponDetailViewStatus: .usageConfirm)
    }
    
    /// 使う(詳細)
    @IBAction private func tappedUseInConfirm(_ sender: UIButton) {
        presenter.useCoupon()
    }
    
    /// 今は使わない
    @IBAction private func tappedUnuseInConfirm(_ sender: UIButton) {
        reloadView(couponDetailViewStatus: .unused)
    }
    
    /// 画面を閉じる
    @objc
    private func close() {
        dismiss(animated: true)
    }
}

extension CouponDetailViewController: CouponDetailView {
    
    func reloadView(couponDetailViewStatus: CouponDetailViewStatus) {
        
        switch couponDetailViewStatus {
        case .unused:
            willUseView.isHidden = false
            usageConfirmView.isHidden = true
            usedView.isHidden = true
            expireLabel.text = presenter.couponEntity.validPeriod()
            
        case .usageConfirm:
            willUseView.isHidden = true
            usageConfirmView.isHidden = false
            usedView.isHidden = true
            expireLabelInUsageConfirmView.text = presenter.couponEntity.validPeriod()
            
        case .used:
            willUseView.isHidden = true
            usageConfirmView.isHidden = true
            usedView.isHidden = false
            usedDateLabel.text = presenter.couponEntity.usedDate
        }
        couponBaseViewHeightLayout.constant = couponDetailViewStatus.couponBaseViewHeight()
    }
}
