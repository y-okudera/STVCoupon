//
//  CouponListCell.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

protocol CouponListCellDelegate: class {
    func tappedWishButton(newValue: CouponEntity)
}

final class CouponListCell: UICollectionViewCell {
    
    var delegate: CouponListCellDelegate?
    
    var coupon: CouponEntity? {
        didSet {
            self.setCouponData(couponEntity: coupon)
        }
    }
    
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var expireView: UIView!
    @IBOutlet private weak var expireTitleLabel: UILabel!
    @IBOutlet private weak var expireLabel: UILabel!
    @IBOutlet private weak var wishButton: UIButton!
    @IBOutlet private weak var titleViewWidthLayout: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightConstraint = self.contentView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let topConstraint = self.contentView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        titleViewWidthLayout.constant = type(of: self).width
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layoutIfNeeded()
    }
    
    @IBAction func tappedWishButton(_ sender: UIButton) {
        self.coupon?.wished.toggle()
        
        guard let couponEntity = self.coupon else {
            return
        }
        delegate?.tappedWishButton(newValue: couponEntity)
    }
}

extension CouponListCell {
    
    private func setCouponData(couponEntity: CouponEntity?) {
        
        guard let couponEntity = couponEntity else {
            return
        }
        
        if let usedDate = couponEntity.usedDate {
            setLayoutWhenCouponUsed(usedDate: usedDate)
        } else {
            setLayoutWhenCouponUnused(couponEntity: couponEntity)
        }
        
        // クーポンタイトル
        titleLabel.text = String(format: "COUPON_LIST_TITLE".localized(), couponEntity.priceDown.withComma)
        // いいねボタン
        wishButton.isSelected = couponEntity.wished
        
        // 上だけ角丸にする設定
        self.roundingCorners(view: titleView,
                             byRoundingCorners: [.topLeft, .topRight],
                             cornerRadii: CGSize(width: 20, height: 20))
        
        // 下だけ角丸にする設定
        self.roundingCorners(view: expireView,
                             byRoundingCorners: [.bottomLeft, .bottomRight],
                             cornerRadii: CGSize(width: 10, height: 10))
    }
    
    /// 使用前のクーポンのレイアウト
    private func setLayoutWhenCouponUnused(couponEntity: CouponEntity) {
        // 有効期限タイトル設定
        expireTitleLabel.text = "EXPIRE".localized()
        expireTitleLabel.font = .systemFont(ofSize: 14.0)
        expireTitleLabel.textColor = .lightGray
        
        // 有効期限設定
        expireLabel.text = couponEntity.validPeriod()
        expireLabel.font = .boldSystemFont(ofSize: 17.0)
        expireLabel.textColor = .black
        
        // 透過度設定
        titleView.alpha = 1.0
        expireView.alpha = 1.0
    }
    
    /// 使用後のクーポンのレイアウト
    private func setLayoutWhenCouponUsed(usedDate: String) {
        // 有効期限タイトル設定
        expireTitleLabel.text = "USED".localized()
        expireTitleLabel.font = .boldSystemFont(ofSize: 17.0)
        expireTitleLabel.textColor = .black
        
        // 有効期限設定
        expireLabel.text = usedDate
        expireLabel.font = .systemFont(ofSize: 14.0)
        expireLabel.textColor = .lightGray
        
        // 透過度設定
        titleView.alpha = 0.5
        expireView.alpha = 0.5
    }
    
    /// 角丸の設定
    private func roundingCorners(view: UIView, byRoundingCorners: UIRectCorner, cornerRadii: CGSize) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: byRoundingCorners,
                                cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
}

extension CouponListCell: CollectionViewNibRegistrable {}
