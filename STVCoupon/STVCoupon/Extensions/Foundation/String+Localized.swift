//
//  String+Localized.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

extension String {    
    /// ローカライズした文字列を取得する
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
