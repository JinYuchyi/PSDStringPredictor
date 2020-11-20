//
//  CGRectExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 19/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation
extension CGRect{
//    private func Distance(target rect: CGRect) -> CGFloat{
//        var distance: CGFloat = 0
//        distance = (Self.minX - rect.minX) * (Self.minX - rect.minX) + (Self.minY - rect.minY) * (Self.minY - rect.minY)
//        return distance
//    }
    func IsSame(target rect: CGRect) -> Bool {
        //If two rect overlap
//        if ((rect.minX < self.maxX && rect.minX > self.minX) || (rect.maxX < self.maxX && self.maxX > self.minX) ){
//
//                return true
//
//        }
//        return false
        if ( abs(self.midX - rect.midX) < 20 && abs(self.midY - rect.midY) < 20 ) {
            print("Same: \(self.midX) - \(rect.midX), \(self.midY) - \(rect.midY)")

            return true
        }
        
        return false

    }
}
