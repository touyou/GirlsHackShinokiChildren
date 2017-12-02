//
//  UIColor+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: - Color Set

extension UIColor {
    
    struct MusicApp {
        
        static var white: UIColor { return UIColor(hex: "#FFFFFF") }
        static var magenta: UIColor { return UIColor(hex: "#FF005F") }
    }
}

// MARK: - Hex Color

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha = alpha
        var hex = hex
        
        if hex.hasPrefix("#") {
            
            let index = hex.characters.index(hex.startIndex, offsetBy: 1)
            hex = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: UInt64 = 0
        if scanner.scanHexInt64(&hexValue) {
            
            switch hex.characters.count {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8) / 15
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15
                blue = CGFloat(hexValue & 0x00F) / 15
            case 4:
                red = CGFloat((hexValue & 0xF000) >> 12) / 15
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15
                alpha = CGFloat(hexValue & 0x000F) / 15
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255
                blue = CGFloat(hexValue & 0x0000FF) / 255
            case 8:
                red = CGFloat((hexValue & 0xFF000000) >> 24) / 255
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255
                alpha = CGFloat(hexValue & 0x000000FF) / 255
            default:
                print("無効な色コードです。")
            }
        } else {
            
            print("スキャン中にエラーが発生しました。")
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
