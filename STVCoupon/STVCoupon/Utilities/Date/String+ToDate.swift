//
//  String+ToDate.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/08/19.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

extension String {

    func toDate(dateFormat: DateFormat = .yMd_None) -> Date? {
        let dateFormatter = DateFormatter.sharedFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.locale = .enUsPosix
        dateFormatter.timeZone = .gmt
        return dateFormatter.date(from: self)
    }
}
