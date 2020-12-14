//
//  InteractiveViewModel.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class InteractiveViewModel: ObservableObject{
    @Published var selectStartLocation: CGPoint = CGPoint.init(x: -99999, y: -99999)
    @Published var selectEndLocation: CGPoint = CGPoint.init(x: -99999, y: -99999)
    @Published var selectionRect: CGRect = CGRect.init()
    
    func CalcSelectionRect(_ p: CGPoint) -> CGRect{
        if selectStartLocation.x == -99999 {
            selectStartLocation = p
        }
        var _x = 0
        var _y = 0
        var _w = Int(abs(p.x - selectStartLocation.x))
        var _h = Int(abs(p.x - selectStartLocation.x))
        if p.x < selectStartLocation.x {
            _x = Int(p.x)
        }else{
            _x = Int(selectStartLocation.x)
        }
        if p.y < selectStartLocation.y {
            _y = Int(p.y)
        }else{
            _y = Int(selectStartLocation.y)
        }
        let result = CGRect.init(x: _x, y: _y, width: _w, height: _h)
        return result
    }
    
    
}
