//
//  CouponListProvider.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

final class CouponListProvider: NSObject {
    
    var couponListCellDelegate: CouponListCellDelegate?
    private(set) var couponEntities = [CouponEntity]()
    
    func set(couponEntities: [CouponEntity]) {
        self.couponEntities = couponEntities
    }
}

extension CouponListProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // クーポン0件の場合は、0件であることを表示するためのセルを表示する
        if couponEntities.isEmpty {
            return 1
        }
        return couponEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if couponEntities.isEmpty {
            let emptyCell: CouponListEmptyCell = collectionView.dequeueReusableCell(for: indexPath)
            return emptyCell
        }
        
        let cell: CouponListCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.coupon = couponEntities[indexPath.row]
        cell.delegate = self.couponListCellDelegate
        return cell
    }
}
