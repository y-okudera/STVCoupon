//
//  ExceptionCatchable.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/09/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

protocol ExceptionCatchable {}

extension ExceptionCatchable {
    func execute(_ tryBlock: () -> ()) throws {
        try ExceptionHandler.catchException(try: tryBlock)
    }
}
