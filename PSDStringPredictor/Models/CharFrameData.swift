//
//  CharRectData.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

struct CharFrame: Identifiable, Hashable{
    var id: UUID
    var rect: CGRect
    var char: String
    var predictedSize: Int16
    
    init(){
        id = UUID()
        rect = CGRect.init()
        char = ""
        predictedSize = 0
    }
    
    init(rect: CGRect, char: String, predictedSize: Int16){
        id = UUID()
        self.rect = rect
        self.char = char
        self.predictedSize = predictedSize
    }
    
}


