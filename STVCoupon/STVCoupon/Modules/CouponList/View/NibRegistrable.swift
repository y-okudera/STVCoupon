//
//  NibRegistrable.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

// MARK: - CollectionViewNibRegistrable
protocol CollectionViewNibRegistrable where Self: UICollectionViewCell {
    
    static var width: CGFloat { get }
    
    /// CollectionViewにNibを登録する
    ///
    /// - Parameter collectionView: 登録先のCollectionView
    static func register(collectionView: UICollectionView)
    
    /// セルの規定サイズを取得する
    static func prototypeCellSize() -> CGSize
}

extension CollectionViewNibRegistrable {
    
    static var width: CGFloat {
        return (UIScreen.main.bounds.width * 0.9).rounded()
    }
    
    static func register(collectionView: UICollectionView) {
        let nib = UINib(nibName: identifier, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    static func prototypeCellSize() -> CGSize {
        let prototypeCell = UINib(nibName: identifier, bundle: nil)
            .instantiate(withOwner: nil, options: nil)
            .first as! Self
        prototypeCell.bounds.size.width = width
        prototypeCell.contentView.bounds.size.width = width
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .defaultLow)
        return size
    }
}

