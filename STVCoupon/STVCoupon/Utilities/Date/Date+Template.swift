//
//  Date+Template.swift
//  STVCoupon
//
//  Created by Yuki Okudera on 2019/08/25.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

extension DateFormatter {
    // テンプレートの定義
    enum Template: String {
        case date = "yMd" // 2017/1/1
    }

    func setTemplate(_ template: Template) {
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}

extension Date {
    
    /// 端末で設定されているLocaleに応じたカスタムフォーマット
    func toString(template: DateFormatter.Template) -> String {
        let dateFormatter = DateFormatter.sharedFormatter()
        dateFormatter.setTemplate(template)
        return dateFormatter.string(from: self)
    }
}
