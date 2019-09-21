//
//  CouponListAPIReturnCode.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

enum CouponListAPIReturnCode: String {
    
    case normal = "0000"
    case requestParameter = "1001"
    case others = "9999"
    
    func userMessage() -> String {
        switch self {
        case .normal:
            return ""
        case .requestParameter:
            return "COUPON_LIST_ERROR_1001".localized()
        case .others:
            return "COUPON_LIST_ERROR_9999".localized()
        }
    }
}
