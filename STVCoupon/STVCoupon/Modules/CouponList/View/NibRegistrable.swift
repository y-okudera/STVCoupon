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
    
    /// CollectionViewにNibを登録する
    ///
    /// - Parameter collectionView: 登録先のCollectionView
    static func register(collectionView: UICollectionView)
}

extension CollectionViewNibRegistrable {
    
    static func register(collectionView: UICollectionView) {
        let nib = UINib(nibName: identifier, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

