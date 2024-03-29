//
//  ColorExtensions.swift
//  TLog
//
//  Created by D on 3/4/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

