//
//  Color+Extension.swift
//  EnergyManagementSystemSwiftUI
//
//  Created by Jonashio on 5/8/22.
//

import SwiftUI

extension Color {
    init(amount: Float) {
        let percentKelvin = CGFloat(amount / 100)
        var red, green, blue: CGFloat

        red =   Self.clamp(percentKelvin <= 66 ? 255 : (329.698727446 * pow(percentKelvin - 60, -0.1332047592)))
        green = Self.clamp(percentKelvin <= 66 ? (99.4708025861 * log(percentKelvin) - 161.1195681661) : 288.1221695283 * pow(percentKelvin, -0.0755148492))
        blue =  Self.clamp(percentKelvin >= 66 ? 255 : (percentKelvin <= 19 ? 0 : 138.5177312231 * log(percentKelvin - 10) - 305.0447927307))
        
        self.init(red: red / 255, green: green / 255, blue: blue / 255, opacity: 1.0)
    }
    
    private static func clamp(_ value: CGFloat) -> CGFloat {
        return value > 255 ? 255 : (value < 0 ? 0 : value)
    }
    
    init(hex: String, alpha: Double = 1) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff, opacity: alpha)
    }
}
