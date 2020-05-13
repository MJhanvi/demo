//
//  Extension.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
        
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
            
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = CGSize(width: 0, height:0)
            self.layer.shadowRadius = 5
        
    }
}
