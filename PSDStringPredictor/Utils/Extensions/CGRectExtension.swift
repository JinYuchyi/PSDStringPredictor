//
//  CGRectExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
extension CGRect{

    
    func IsSame(target rect: CGRect) -> Bool {
        if ( abs(self.midX - rect.midX) < 20 && abs(self.midY - rect.midY) < 20 ) {

            return true
        }
        
        if (self.maxX - rect.maxX) * (self.maxX - rect.maxX) + (self.maxY - rect.maxY) * (self.maxY - rect.maxY) < 100 {
            return true
        }
        
        if (self.minX - rect.minX) * (self.minX - rect.minX) + (self.minY - rect.minY) * (self.minY - rect.minY) < 100 {
            return true
        }
        
        return false

    }
}
