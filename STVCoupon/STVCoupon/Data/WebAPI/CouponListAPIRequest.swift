//
//  CouponListAPIRequest.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

final class CouponListAPIRequest: APIRequest {
    
    typealias Response = CouponListAPIResponse
    typealias ErrorResponse = CouponListAPIErrorResponse
    var path: String = "/couponList"
    var parameters: [String: Any] = [:]
}
