//
//  Extensions.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/1.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
