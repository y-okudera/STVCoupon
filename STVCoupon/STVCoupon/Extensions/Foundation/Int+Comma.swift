//
//  Int+Comma.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

extension Int {
    var withComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let commaString = formatter.string(from: self as NSNumber)
        return commaString ?? "\(self)"
    }
}
