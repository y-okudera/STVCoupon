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
    
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var expireView: UIView!
    @IBOutlet private weak var expireTitleLabel: UILabel!
    @IBOutlet private weak var expireLabel: UILabel!
    @IBOutlet private weak var wishButton: UIButton!
    
    @IBOutlet weak var titleViewWidthLayout: NSLayoutConstraint!
    @IBOutlet weak var titleViewHeightLayout: NSLayoutConstraint!
    
    var coupon: CouponEntity? {
        didSet {
            self.setCouponData(couponEntity: coupon)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = self.contentView.leftAnchor.constraint(equalTo: self.leftAnchor)
        let rightConstraint = self.contentView.rightAnchor.constraint(equalTo: self.rightAnchor)
        let topConstraint = self.contentView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        titleViewWidthLayout.constant = UIScreen.main.bounds.width - 16
        titleViewHeightLayout.constant = 300
    }
    
    @IBAction func tappedWishButton(_ sender: UIButton) {
        self.coupon?.wished.toggle()
        
        guard let couponEntity = self.coupon else {
            return
        }
        delegate?.tappedWishButton(newValue: couponEntity)
    }
}

extension CouponListCell: CollectionViewNibRegistrable {}

extension CouponListCell {
    
    private func setCouponData(couponEntity: CouponEntity?) {
        
        guard let couponEntity = couponEntity else {
            return
        }
        
        titleLabel.text = String(format: "COUPON_LIST_TITLE".localized(), couponEntity.priceDown.withComma)
        
        // クーポン利用後の場合
        if let usedDate = couponEntity.usedDate {
            expireTitleLabel.text = "USED".localized()
            expireTitleLabel.font = .boldSystemFont(ofSize: expireTitleLabel.font.pointSize)
            
            expireLabel.text = usedDate
            expireLabel.font = .systemFont(ofSize: expireLabel.font.pointSize)
            
            titleView.alpha = 0.5
            expireView.alpha = 0.5
        } else {
            expireTitleLabel.text = "EXPIRE".localized()
            expireTitleLabel.font = .systemFont(ofSize: expireTitleLabel.font.pointSize)
            
            expireLabel.text = couponEntity.validPeriod()
            expireLabel.font = .boldSystemFont(ofSize: expireLabel.font.pointSize)
            
            titleView.alpha = 1.0
            expireView.alpha = 1.0
        }
        
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
