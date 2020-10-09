//
//  ArrayExtension.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

//protocol P {}
//extension Int: P {}
extension Array  {
    
    func FindNearest(toNumber num: Int) -> Int{
        if ( num == Int(self[0] as! NSNumber) || num == Int(self.last as! NSNumber) ){ return num }

        var startIndex = 0
        var edgeIndex = self.count
        var tmpArray = Array(self)
        var nearest = 0
        var keepSearch = true

        
        func Split(keepFrontHalf isfront: Bool){
            var halfCount: Float = Float(tmpArray.count) / 2.0
            edgeIndex = Int(halfCount)
            if (isfront == true){
                tmpArray = Array(tmpArray[0..<edgeIndex])
            }
            else{
                tmpArray = Array(tmpArray[edgeIndex..<tmpArray.count])
            }
            
            //Exit
            if(tmpArray.count == 3 || tmpArray.count == 2){
                var minDist = 10000
                for index in 0..<tmpArray.count {
                    let dist = abs(Int(tmpArray[index] as! NSNumber) - num)
                    if ( dist < minDist) {
                        minDist = dist
                        nearest = Int(tmpArray[index] as! NSNumber)
                    }
                }
                keepSearch = false
            }
            
            //If no stop order, keeping looping
            if ( keepSearch == true ){
                if ( num == Int( self[edgeIndex] as! NSNumber) ){
                    nearest = num
                    keepSearch = false
                }
                else if (num > Int( self[edgeIndex] as! NSNumber) ){
                    Split(keepFrontHalf: false)
                }
                else{
                    Split(keepFrontHalf: true)
                }
            }
            
        }
        
        return nearest
        

    }
//    func FindClosestItem(key num: Int) -> [Int]{
//        //let sizes = [Int](self.keys)
//        for key in self.keys.sorted(by: <) {
//            print()
//        }
//
//        return []
//    }
}
