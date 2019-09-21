//
//  Date+Compare.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/08/19.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

extension Date {
    
    /// selfと引数のdateのうち、早い方(過去の方)を取得する
    ///
    /// - Parameter date: The date to compare to self
    /// - Returns: 早い日付
    func earlierDate(_ date: Date) -> Date {
        return (self.timeIntervalSince1970 <= date.timeIntervalSince1970) ? self : date
    }

    /// selfと引数のdateのうち、遅い方(未来の方)を取得する
    ///
    /// - Parameter date: The date to compare to self
    /// - Returns: 遅い日付
    func laterDate(_ date: Date) -> Date {
        return (self.timeIntervalSince1970 >= date.timeIntervalSince1970) ? self : date
    }
}
